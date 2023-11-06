//
//  FlikerImageViewModel.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import UIKit
import RealmSwift

class FlickrImagesViewModel {
    
    weak var delegate: FlickrImagesViewModelDelegate?
    internal var isFetchingNextPage = false
    private var currentPage = 1
    
    func fetchImages(page: Int) {
        var components = URLComponents(string: Constants.baseUrl)
        let imageListBody = ImageListBody(page: page)
        components?.queryItems = imageListBody.dictionary.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        guard let url = components?.url else {
            return
        }
        
        let request = URLRequest(url: url)
        let apiRequest = ApiRequest<PhotosListResponse>(request: request)
        
        delegate?.didStartFetchingImages()

        apiRequest.execute { [weak self] result in
            DispatchQueue.main.async {
                let realm = try! Realm()
                switch result {
                case .success(let response):
                    let photos = response.photos?.photo ?? []
                    // Save photos to Realm
                    try! realm.write {
                        realm.add(photos, update: .modified)
                    }
                    let images = photos.map { FlickrPictureModel(model: $0) }
                    let uiModel = FlickrPictureUIModel(
                        currentPage: response.photos?.page ?? 1,
                        lastPage: response.photos?.pages ?? 1,
                        images: images)
                    self?.delegate?.didFetchImages(uiModel)
                case .failure(let error):
                    self?.delegate?.didFailWithError(error)
                }
            }
        }
    }
    
    func fetchNextPage() {
        if !isFetchingNextPage {
            isFetchingNextPage = true
            delegate?.didStartFetchingImages()
            currentPage += 1
            fetchImages(page: currentPage)
        }
    }
}
