//
//  CPPropertyView.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

enum ItemInfoType {
    case releaseDate, language, rating
}

class CPPropertyView: UIView {
    
    let symbolImageView = UIImageView()
    let titleLabel      = CPTitleLabel(textAlignment: .left, fontSize: 14)
    let valueLabel      = CPTitleLabel(textAlignment: .center, fontSize: 14)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubviews(symbolImageView, titleLabel, valueLabel)
        self.translatesAutoresizingMaskIntoConstraints            = false
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor   = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            valueLabel.leadingAnchor.constraint(equalTo: symbolImageView.leadingAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 17),
            valueLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4)
        ])
    }
    
    
    func set(itemInfoType: ItemInfoType, withValue value: String?) {
        switch itemInfoType {
        case .rating:
            symbolImageView.image   = SFSymbols.rating
            titleLabel.text         = "Rating"
            
        case .releaseDate:
            symbolImageView.image   = SFSymbols.play
            titleLabel.text         = "ReleaseDate"
            valueLabel.text         = "No Date"
            
        case .language:
            symbolImageView.image   = SFSymbols.speaker
            titleLabel.text         = "Language"
            valueLabel.text         = "No Language"
        }
        
        if let value = value {
            valueLabel.text         = value
            
        }
    }
}
