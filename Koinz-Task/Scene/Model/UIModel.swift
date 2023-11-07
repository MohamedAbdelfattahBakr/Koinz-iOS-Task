//
//  UIModel.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import Foundation

struct FlickrPictureModel {
    let image: FlickrPictureType
    let photo: FlickrPhoto
    
    init(model: FlickrPhoto) {
        photo = model
        image = .url("\(Constants.imageBaseUrl)\(model.server)/\(model.id)_\(model.secret).jpg")
    }
}
