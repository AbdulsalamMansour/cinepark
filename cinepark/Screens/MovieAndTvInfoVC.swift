//
//  MovieAndTvInfoVC.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

enum InfoVCPresentation {
    case modal
    case navigationController
}
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
    
    var cineparkItem: CineparkItem!
    var presentationType: InfoVCPresentation!
    
    init(cineparkItem: CineparkItem, presentation: InfoVCPresentation) {
        super.init(nibName: nil, bundle: nil)
        self.cineparkItem       = cineparkItem
        self.presentationType   = presentation
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
        
        var doneButton: UIBarButtonItem!
        var favoriteButton: UIBarButtonItem!
        
        if presentationType == .modal {
            doneButton = UIBarButtonItem(image: SFSymbols.xmark, style: .done, target: self, action: #selector(self.dismssVC))
            favoriteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAddToFavoritesClick))
        } else {
            doneButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.onDeleteFromFavoritesClick))
        }
                
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
            contentView.heightAnchor.constraint(equalToConstant: view.frame.size.height)
        ])
    }
    
    func configurePosterImageView(){
        
        contentView.addSubview(posterImageView)
        posterImageView.downloadImage(fromURL: cineparkItem.posterPath!)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            posterImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            posterImageView.heightAnchor.constraint(equalToConstant: (view.frame.size.width / 2) * 1.5),
        ])
    }
    
    func configureTitleLabel(){
        contentView.addSubview(titleLabel)
        
        if let title = cineparkItem.title{
            titleLabel.text = title
        } else {
            titleLabel.text = cineparkItem.name
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
        overviewLabel.text               = cineparkItem.overview
        
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
        
        let rating: String = String(format:"%.1f", cineparkItem.voteAverage!)
        ratingView.set(itemInfoType: .rating, withValue: rating)
        languageView.set(itemInfoType: .language, withValue: cineparkItem.originalLanguage)
        if let date = cineparkItem.releaseDate {
            dateView.set(itemInfoType: .releaseDate, withValue: date)
        } else {
            dateView.set(itemInfoType: .releaseDate, withValue: cineparkItem.firstAirDate)
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
    
    @objc func popCurrentVC(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func onAddToFavoritesClick() {
        addItemToFavorites(cineparkItem: cineparkItem)
    }
    
    @objc func onDeleteFromFavoritesClick(){
        removeItemFromFavorites(cineparkItem: cineparkItem)
    }
    
    func addItemToFavorites(cineparkItem: CineparkItem) {
        PersistenceManager.updateWith(favorite: cineparkItem, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentCPAlertOnMainThread(title: "Success!", message: "You have successfully favorited this item", buttonTitle: "Ok")
                return
            }
            
            self.presentCPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    func removeItemFromFavorites(cineparkItem: CineparkItem){
        PersistenceManager.updateWith(favorite: cineparkItem, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.popCurrentVC()
                return
            }
            
            self.presentCPAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
}
