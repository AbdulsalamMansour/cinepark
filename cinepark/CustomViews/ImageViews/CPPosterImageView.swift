//
//  CPPosterImageView.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

class CPPosterImageView: UIImageView {
    
    let cache               = PosterImageManager.shared.cache
    let placeholderImage    = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(fromURL url: String){
        PosterImageManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                DispatchQueue.main.async { self.image = image }
            }
        }
    }
}
