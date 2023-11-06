//
//  ImagesModel.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import Foundation
import RealmSwift

struct PhotosListResponse: Codable {
    let photos: FlickrPhotos?
    let stat: String
    let message: String?
}

struct FlickrPhotos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [FlickrPhoto]?
}


struct ImageListBody: Codable {
    init(page: Int) {
        self.page = page
    }
    
    var method = "flickr.photos.search"
    var format = "json"
    var text = "Color"
    var page: Int
    var per_page = 20
    var api_key = Constants.apiKey
    var nojsoncallback = 1
}

extension ImageListBody {
    var dictionary: [String: Any] {
        return [
            "method": method,
            "format": format,
            "text": text,
            "page": page,
            "per_page": per_page,
            "api_key": api_key,
            "nojsoncallback": nojsoncallback
        ]
    }
}

class FlickrPhoto: Object, Codable {
    @objc dynamic var id = ""
    @objc dynamic var owner = ""
    @objc dynamic var secret = ""
    @objc dynamic var server = ""
    @objc dynamic var farm = 0
    @objc dynamic var title = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
