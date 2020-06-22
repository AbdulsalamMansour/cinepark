//
//  BrowseVC.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/21/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

class MostViewedVC: UIViewController {
    
    let logoImageView   = UIImageView()
    let moviesButton    = CPButton(backgroundColor: AppColors.primaryViolet, title: "Movies")
    let tvButton        = CPButton(backgroundColor: AppColors.primaryViolet, title: "TV")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, moviesButton, tvButton)
        configureLogoImageView()
        configureMoviesButton()
        configureTvButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func openMoviesList() {
        pushMoviesAndTvListVC(contentType: .movies)
    }
    
    @objc func openTvList() {
        pushMoviesAndTvListVC(contentType: .tv)
    }
    
    func pushMoviesAndTvListVC(contentType: ContentType){
        let moviesAndTvListVC = MoviesAndTvListVC(contentType: contentType)
        navigationController?.pushViewController(moviesAndTvListVC, animated: true)
    }
    
    //MARK:- UIConfig Methods
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.cpLogo
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 300),
            logoImageView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureMoviesButton() {
        moviesButton.addTarget(self, action: #selector(self.openMoviesList), for: .touchUpInside)

        NSLayoutConstraint.activate([
            moviesButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            moviesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            moviesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            moviesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureTvButton() {
        tvButton.addTarget(self, action: #selector(self.openTvList), for: .touchUpInside)

        NSLayoutConstraint.activate([
            tvButton.topAnchor.constraint(equalTo: moviesButton.bottomAnchor, constant: 15),
            tvButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            tvButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            tvButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
