//
//  FlickrImageCell.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 06/11/2023.
//

import UIKit
import SDWebImage

enum FlickrPictureType {
    case url(String)
    case imageName(String)
}

class FlickrImageCell: UITableViewCell {
    var flickrImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        flickrImageView = UIImageView()
        flickrImageView.translatesAutoresizingMaskIntoConstraints = false
        flickrImageView.contentMode = .scaleAspectFill
        flickrImageView.clipsToBounds = true
        contentView.addSubview(flickrImageView)
        
        NSLayoutConstraint.activate([
            flickrImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            flickrImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            flickrImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            flickrImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with picture: FlickrPictureModel) {
        switch picture.image {
        case .url(let url):
            flickrImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
        default:
            break
        }
    }
}
