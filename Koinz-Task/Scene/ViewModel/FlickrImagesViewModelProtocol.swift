//
//  FlickrImagesViewModelProtocol.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import Foundation

protocol FlickrImagesViewModelDelegate: AnyObject {
    func didStartFetchingImages()
    func didFetchImages(_ model: FlickrPictureUIModel)
    func didFailWithError(_ error: Error)
    
}
