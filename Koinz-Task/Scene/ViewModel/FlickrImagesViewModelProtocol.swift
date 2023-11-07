//
//  FlickrImagesViewModelProtocol.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import Foundation

protocol FlickrImagesViewModelDelegate: AnyObject {
    func didFetchImages(_ model: ResponseBody?)
    func didFailWithError(_ error: Error)
    
}
