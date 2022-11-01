
//  APICaller.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-10-17.
//

import Foundation

class APIHelper {
    
    enum ErrorAPI {
        case networkError
        case loginError
        case registerError
        case otherError
        
        var description: String {
            switch self {
            case .networkError:
                return "Something went wrong. Please try again."
            case .loginError:
                return  "User doesn't exist with provided email and passsword."
            case .registerError:
                return "This email alredy exist."
            case .otherError:
                return "Session expired.Please try again."
            }
        }
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
                                      isUsedToken: Bool = true,
                                      completion: @escaping (T?) -> Void) {
        guard let request = configUrlRequest(query: query,
                                             bodyParams: params,
                                             httpMethod: "POST",
                                             isUsedToken: isUsedToken) else { return }
        fetchRequest(with: request, completion: completion)
    }
    
    func createGetRequest<T:Codable>(query: String,
                                     completion: @escaping (T?) -> Void) {
        guard let request = configUrlRequest(query: query) else { return }
        fetchRequest(with: request, completion: completion)
    }
    
    private func configUrlRequest(query: String,
                                  bodyParams: [String: Any]? = nil,
                                  httpMethod: String = "GET",
                                  isUsedToken: Bool = true) -> URLRequest? {
        guard let url = baseURL?.appendingPathComponent(query) else { return nil}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if isUsedToken {
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
                                         completion: @escaping (T?) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil)
            } else if let data = data {
                guard let result: T = self.decodeResult(data: data) else { return }
                completion(result)
            }
        }.resume()
    }
    
    private func decodeResult<T:Codable>(data: Data) -> T? {
        let result = try? JSONDecoder().decode(T.self, from: data)
        return result
    }
}
