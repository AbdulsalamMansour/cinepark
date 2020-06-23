//
//  FavoriteCell.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    static let reuseID  = "FavoriteCell"
    let posterImageView = CPPosterImageView(frame: .zero)
    let itemTitle       = CPTitleLabel(textAlignment: .left, fontSize: 18)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(favorite: CineparkItem) {
        if let posterPath = favorite.posterPath {
            posterImageView.downloadImage(fromURL: posterPath)
        }
        
        if let title = favorite.title {
            itemTitle.text = title
        } else {
            itemTitle.text = favorite.name
        }
    }
    
    
    private func configure() {
        addSubviews(posterImageView, itemTitle)
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            posterImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            posterImageView.heightAnchor.constraint(equalToConstant: 60),
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            
            itemTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            itemTitle.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 24),
            itemTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            itemTitle.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
