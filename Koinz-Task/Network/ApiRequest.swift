//
//  ApiRequest.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import Foundation

protocol Requestable {
    associatedtype T: Codable
    func execute(completion: @escaping (Result<T, Error>) -> Void)
}

class ApiRequest<T: Codable>: Requestable {
    var request: URLRequest
    var body: [String: Any]?
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func withBody(_ body: [String: Any]?) -> Self {
        self.body = body
        return self
    }
    
    func execute(completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(BaseError.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(BaseError.networkError))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(BaseError.networkError))
            }
        }
        task.resume()
    }
}
