
//  APICaller.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-10-17.
//

import Foundation

class APIHelper {
    
    enum ErrorAPI: Error {
        case badRequest(String)
        case unauthorized(String)
        case others(String)
    }
    
    private let baseURL = URL(string: "https://education.octodev.net/api/v1")
    static var token = ""
    
    private var session: URLSession
    init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration,
                             delegate: nil,
                             delegateQueue: OperationQueue.main)
    }
    
    func createPostRequest<T:Codable>(query: String,
                                      params: [String: Any],
                                      completion: @escaping (Result <T, ErrorAPI>) -> Void) {
        guard let request = configUrlRequest(query: query,
                                             bodyParams: params,
                                             httpMethod: "POST") else { return }
        fetchRequest(with: request, completion: completion)
    }
    
    func createGetRequest<T:Codable>(query: String,
                                     completion: @escaping (Result <T, ErrorAPI>) -> Void) {
        guard let request = configUrlRequest(query: query) else { return }
        fetchRequest(with: request, completion: completion)
    }
    
    private func configUrlRequest(query: String,
                                  bodyParams: [String: Any]? = nil,
                                  httpMethod: String = "GET") -> URLRequest? {
        guard let url = baseURL?.appendingPathComponent(query) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if APIHelper.token != "" {
            request.addValue("Bearer \(APIHelper.token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = httpMethod
        if request.httpMethod == "POST" {
            request.httpBody = configRequestBody(params: bodyParams)
        }
        return request
    }
    
    private func configRequestBody(params: [String: Any]?) -> Data? {
        guard let params = params else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    }
    
    private func fetchRequest<T:Codable>(with request: URLRequest,
                                         completion: @escaping (Result <T, ErrorAPI>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.others(error.localizedDescription)))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  let data = data,
                  statusCode <= 299 && statusCode >= 200 else {
                      self.errorHandler(with: response, data: data, completion: completion)
                      return
                  }
            
            guard let result: T = self.decodeResult(data: data) else { return }
            completion(.success(result))
            
        }.resume()
    }
    
    private func errorHandler <T:Codable>(with response: URLResponse?,
                                          data: Data?,
                                          completion: @escaping (Result <T, ErrorAPI>) -> Void) {
        guard let response = response as? HTTPURLResponse else  {
            completion(.failure(.others("Someting went wrong. Please try again")))
            return
        }
        
        switch response.statusCode {
        case 400:
            guard let data = data,
                  let  errorBadRequest: ErrorResponse = self.decodeResult(data: data) else {
                      completion(.failure(.badRequest("Someting went wrong with your request")))
                      return
                  }
            completion(.failure(.badRequest(errorBadRequest.details)))
        case 401: completion(.failure(.unauthorized("Session expired")))
        default: completion(.failure(.others("Someting went wrong. Please try again")))
        }
    }
    
    private func decodeResult<T:Codable>(data: Data) -> T? {
        let result = try? JSONDecoder().decode(T.self, from: data)
        return result
    }
}
