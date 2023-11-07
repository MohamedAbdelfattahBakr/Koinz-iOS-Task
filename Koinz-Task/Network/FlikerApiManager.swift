//
//  FlikerApiManager.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 07/11/2023.
//

import Foundation

class FlikerApiManager: NetworkManager, FlikerApiManagerProtocol {
    
    private enum EndPoint: String {
          case reset = "rest/"
      }
      
    //MARK: - FetchFlikerData
    
    func fetchFlikerData(requestModel: PhotoRequest, onCompletation: @escaping ((Result<PhotosResponse, Error>) -> Void)) {
        let queryParams = requestModel.dictionary
        
        let router = Router(httpMethod: .get, urlPath: EndPoint.reset.rawValue,
                            queryParams: queryParams)
        super.performRequest(router: router,
                             dataType: PhotosResponse.self, decoder: JSONDecoder(), onComplete: onCompletation)
    }
}

//MARK: - FlikerApiManagerProtocol

protocol FlikerApiManagerProtocol: AnyObject {
    func fetchFlikerData(requestModel: PhotoRequest, onCompletation: @escaping ((Result<PhotosResponse, Error>)->Void))
}
