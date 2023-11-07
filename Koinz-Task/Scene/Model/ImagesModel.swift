//
//  ImagesModel.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import Foundation
import RealmSwift

struct PhotosResponse: Codable {
    let photos: ResponseBody?
    let stat: String
    let message: String?
}

struct ResponseBody: Codable {
    let page, pages, perpage, total: Int?
    let photo: [FlickrPhoto]?
    
    init(page: Int?, pages: Int?, perpage: Int? = nil, total: Int? = nil, photo: [FlickrPhoto]?) {
        self.page = page
        self.pages = pages
        self.perpage = perpage
        self.total = total
        self.photo = photo
    }
}


struct PhotoRequest: Codable {
    init(page: Int) {
        self.page = page
    }
    var method = "flickr.photos.search"
    var format = "json"
    var text = "Color"
    var page: Int
    var per_page = 20
    var api_key = Constants.apiKey
    var nojsoncallback = 50
}

extension PhotoRequest {
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
struct FlickrPhoto: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
}

class RealmFlickrPhoto: Object {
    @objc dynamic var id = ""
    @objc dynamic var owner = ""
    @objc dynamic var secret = ""
    @objc dynamic var server = ""
    @objc dynamic var farm = 0
    @objc dynamic var title = ""
    @objc dynamic var pages: Int = 0
    @objc dynamic var currentPage: Int = 0

    override class func primaryKey() -> String? {
        return "id"
    }
}

