//
//  Router.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 07/11/2023.
//

import Foundation

struct Router {
    
    //MARK: - Constants
    private let baseUrl = Constants.baseUrl
    private let httpMethod: HttpMethod
    private let urlPath: String
    private let queryParams: [String:Any]?
    
    //MARK: - Initilaize
    init(httpMethod: HttpMethod, urlPath: String,queryParams: [String:Any]? = nil) {
        self.urlPath = urlPath
        self.httpMethod = httpMethod
        self.queryParams = queryParams
    }
    
    func createUrlRequest() -> URLRequest? {
        let urlString = "\(baseUrl)\(urlPath)"
        if let queryParams = queryParams {
            var components = URLComponents(string: urlString)
            components?.queryItems = queryParams.map { (key,value) in
               return URLQueryItem(name: key, value: "\(value)")
            }
            print("QueryParams:\(components?.queryItems ?? [])")
            if let url = components?.url {
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = httpMethod.rawValue
                return urlRequest
            }
        } else {
            guard let url = URL(string: urlString) else {return nil}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod.rawValue
            return urlRequest
        }
        return nil
    }
}
