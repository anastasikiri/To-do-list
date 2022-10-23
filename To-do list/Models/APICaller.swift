//
//  APICaller.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-10-17.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()    
    
    let baseURLString = "https://education.octodev.net/api/v1/"
    static var token = ""
    
    func executePostRequest(with query: String,
                            params: [String: Any],
                            completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let url = URL(string: baseURLString + query) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(APICaller.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params,
                                                       options: .prettyPrinted)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            } else if let data = data {
                completion(try! JSONSerialization.jsonObject(with: data, options: [])
                           as? [String : Any], nil)
            }
        }.resume()
    }
    
    func executeGetRequest(with query: String,
                           completion: @escaping ([Task]?, Error?) -> Void) {
        guard let url = URL(string: baseURLString + query) else { return }
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(APICaller.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode([Task].self, from: data)
                    completion(result, nil)
                }
                catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}

