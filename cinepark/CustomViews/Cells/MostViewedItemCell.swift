//
//  MostViewedItemCell.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

class MostViewedItemCell: UICollectionViewCell {
    static let reuseID  = "MostViewedItemCell"
    let posterImageView = CPPosterImageView(frame: .zero)
    let titleLabel      = CPTitleLabel(textAlignment: .center, fontSize: 12)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(cineparkItem: CineparkItem) {
        if let posterPath = cineparkItem.posterPath {
            posterImageView.downloadImage(fromURL: posterPath)
        }
        
        if let title = cineparkItem.title {
            titleLabel.text = title
        } else if let name = cineparkItem.name {
            titleLabel.text = name
        }
    }
    
    
    private func configure() {
        addSubviews(posterImageView, titleLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
