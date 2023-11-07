//
//  FlickrImagesCoordinator.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import UIKit

protocol Cordinator: AnyObject {
    func start()
}

class FlickrImagesCoordinator: Cordinator {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let apiManager = FlikerApiManager()
        let realmManager = RealmManager()
        let viewModel = FlickrImagesViewModel(coordinator: self,
                                              apiManager: apiManager,
                                              realmManager: realmManager)
        let viewController = FlikerImageViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: true)
    }
}
