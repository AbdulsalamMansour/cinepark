//
//  MovieAndTvInfoVC.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

class MovieAndTvInfoVC: UIViewController {
    
    let scrollView              = UIScrollView()
    let contentView             = UIView()
    let posterImageView         = CPPosterImageView(frame: .zero)
    let titleLabel              = CPTitleLabel(textAlignment: .left, fontSize: 20)
    let overviewLabel           = CPBodyTextView()
    let propertyContainerView   = UIView()
    let ratingView              = CPPropertyView()
    let dateView                = CPPropertyView()
    let languageView            = CPPropertyView()
    
    let padding: CGFloat        = 12
    
    var result: CineParkItem!
    
    init(result: CineParkItem) {
        super.init(nibName: nil, bundle: nil)
        self.result = result
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configurePosterImageView()
        configureTitleLabel()
        configureOverviewLabel()
        configurePropertyContainerView()
        configurePropertiesViews()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(image: SFSymbols.xmark, style: .done, target: self, action: #selector(self.dismssVC))
        let favoriteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAddToFavoritesClick))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = favoriteButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 620)
        ])
    }
    
    func configurePosterImageView(){
        
        contentView.addSubview(posterImageView)
        posterImageView.downloadImage(fromURL: result.posterPath!)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            posterImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            posterImageView.heightAnchor.constraint(equalToConstant: (view.frame.size.width / 2) * 1.5),
        ])
    }
    
    func configureTitleLabel(){
        contentView.addSubview(titleLabel)
        
        if let title = result.title{
            titleLabel.text = title
        } else {
            titleLabel.text = result.name
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor,constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
    func configureOverviewLabel(){
        contentView.addSubview(overviewLabel)
        overviewLabel.text               = result.overview
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 7),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: padding),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
        
    }
    
    func configurePropertyContainerView(){
        contentView.addSubview(propertyContainerView)
        propertyContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            propertyContainerView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: padding),
            propertyContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            propertyContainerView.heightAnchor.constraint(equalToConstant: 400),
            propertyContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding)
        ])
    }
    
    func configurePropertiesViews(){
        propertyContainerView.addSubviews(ratingView, dateView, languageView)
        
        let rating: String = String(format:"%.1f", result.voteAverage!)
        ratingView.set(itemInfoType: .rating, withValue: rating)
        languageView.set(itemInfoType: .language, withValue: result.originalLanguage)
        if let date = result.releaseDate {
            dateView.set(itemInfoType: .releaseDate, withValue: date)
        } else {
            dateView.set(itemInfoType: .releaseDate, withValue: result.firstAirDate)
        }
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: propertyContainerView.topAnchor,constant: padding),
            ratingView.leadingAnchor.constraint(equalTo: propertyContainerView.leadingAnchor),
            ratingView.trailingAnchor.constraint(equalTo: propertyContainerView.trailingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 60),
            
            languageView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: padding),
            languageView.leadingAnchor.constraint(equalTo: propertyContainerView.leadingAnchor),
            languageView.trailingAnchor.constraint(equalTo: propertyContainerView.trailingAnchor),
            languageView.heightAnchor.constraint(equalToConstant: 60),
            
            dateView.topAnchor.constraint(equalTo: languageView.bottomAnchor, constant: padding),
            dateView.leadingAnchor.constraint(equalTo: propertyContainerView.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: propertyContainerView.trailingAnchor),
            dateView.heightAnchor.constraint(equalToConstant: 60)
    
            
        ])
        
    }
    
    
    @objc func dismssVC() {
        dismiss(animated: true)
    }
    
    @objc func onAddToFavoritesClick() {
        addItemToFavorites(mostViewedItem: result)
    }
    
    func addItemToFavorites(mostViewedItem: CineParkItem) {
        
        PersistenceManager.updateWith(favorite: result, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentCPAlertOnMainThread(title: "Success!", message: "You have successfully favorited this item", buttonTitle: "Ok")
                return
            }
            
            self.presentCPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
}
