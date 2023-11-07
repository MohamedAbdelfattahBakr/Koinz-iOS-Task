//
//  FlikerImageViewModel.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import UIKit
import RealmSwift
import Realm

class FlickrImagesViewModel {
    
    private weak var coordinator: FlickrImagesCoordinator?
    private var apiManager: FlikerApiManagerProtocol
    private var realmManager: RealmManagerProtocol
    private var currentPage = 1
    private var cachImages = [RealmFlickrPhoto]()
    internal weak var delegate: FlickrImagesViewModelDelegate?

    init(coordinator: FlickrImagesCoordinator,
         apiManager: FlikerApiManagerProtocol,
         realmManager: RealmManagerProtocol) {
        self.coordinator = coordinator
        self.apiManager = apiManager
        self.realmManager = realmManager
        self.fetchCachImage()
    }
    
    func fetchImages() {
        if shoudLoadFromRemote() {
            fetchRemoteImage()
        } else {
            let responseBody = ResponseBody(page: currentPage,
                                            pages: cachImages.first?.pages,
                                            photo: cachImages.map { FlickrPhoto(id: $0.id,
                                                                               owner: $0.owner,
                                                                               secret: $0.secret,
                                                                               server: $0.server,
                                                                               farm: $0.farm,
                                                                               title: $0.title)})
            delegate?.didFetchImages(responseBody)
        }
    }

    func refresh() {
        currentPage = 1
        self.fetchImages()
    }
    
    func canLoadMore(lastPage: Int,
                     currentRow: Int,
                     totalDataCount: Int) -> Bool {
        guard currentRow == totalDataCount - 1 else { return false }
        let nextPage = currentPage + 1
        return nextPage <= lastPage
    }
    
    func loadMore() {
        currentPage += 1
        fetchImages()
    }
    
    func saveToDataBase(photos: [FlickrPhoto],
                        pages: Int) {
        var realmPhotos = [RealmFlickrPhoto]()
        for photo in photos {
            let realmPhoto = RealmFlickrPhoto()
            realmPhoto.pages = pages
            realmPhoto.currentPage = currentPage
            realmPhoto.farm = photo.farm
            realmPhoto.owner = photo.owner
            realmPhoto.id = photo.id
            realmPhoto.secret = photo.secret
            realmPhoto.server = photo.server
            realmPhoto.title = photo.title
            realmPhotos.append(realmPhoto)
        }
        realmManager.saveObjects(data: realmPhotos)
    }
    
    private func fetchRemoteImage() {
        let requestModel = PhotoRequest(page: currentPage)
        apiManager.fetchFlikerData(requestModel: requestModel) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.delegate?.didFetchImages(response.photos)
                case .failure(let error):
                    self?.delegate?.didFailWithError(error)
                }
            }
        }
    }
    
    private func fetchCachImage() {
        realmManager.fetchObjects(dataType: RealmFlickrPhoto.self) { data in
            self.currentPage = data.first?.currentPage ?? 0
            self.cachImages = data
        }
    }
    
    private func shoudLoadFromRemote() -> Bool {
        return cachImages.isEmpty || currentPage != cachImages.first?.currentPage
    }
}
