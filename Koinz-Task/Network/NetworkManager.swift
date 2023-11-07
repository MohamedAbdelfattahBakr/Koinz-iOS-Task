//
//  NetworkManager.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 07/11/2023.
//

import Foundation
    
class NetworkManager: NSObject {
    
    //MARK: - Variables
    lazy var session: URLSession = URLSession.shared
    
    //MARK: - PerformRequest
    func performRequest<T: Decodable>(router: Router, dataType: T.Type, decoder: JSONDecoder, onComplete: @escaping ((Result<T,Error>)->Void)){
        if let urlRequest = router.createUrlRequest() {
            print("UrlRequest:\(urlRequest)")
            let _ = self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
                do {
                    guard let _ = self else {return}
                    guard let data = data else {
                        if let error = error {
                            print("Error:\(error)")
                            onComplete(.failure(error))
                        }
                        return
                    }
                    let jsonData = try decoder.decode(dataType, from: data)
                    print("JsonData:\(data)")
                    onComplete(.success(jsonData))
                } catch let error {
                    print("DecodingError:\(error)")
                    onComplete(.failure(error))
                }
            }.resume()
        }
    }
}

//MARK: - HttpMethod
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case update = "UPDATE"
    case delete = "Delete"
    case patch = "PATCH"
    case put = "PUT"
}
