//
//  AdBannerCell.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 07/11/2023.
//

import UIKit

class AdBannerCell: UITableViewCell {
    private let adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(adImageView)
        
        NSLayoutConstraint.activate([
            adImageView.topAnchor.constraint(equalTo: topAnchor),
            adImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            adImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(with adBanner: AdBanner) {
        adImageView.image = adBanner.image
    }
}
