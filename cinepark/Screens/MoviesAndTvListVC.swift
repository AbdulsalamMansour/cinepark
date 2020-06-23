//
//  MoviesListVC.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/21/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit
import RxSwift

class MoviesAndTvListVC: CPDataLoadingVC {
    
    enum Section { case main }
    
    var cineparkItems: [CineparkItem]           = []
    var filteredCineparkItems: [CineparkItem]   = []
    
    var page                                    = 1
    var hasMoreResults                          = true
    var isLoadingMoreResults                    = false
    var isSearching                             = false
    
    private let disposeBag                      = DisposeBag()
    var contentType: ContentType!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, CineparkItem>!
    
    
    init(contentType: ContentType) {
        super.init(nibName: nil, bundle: nil)
        self.contentType = contentType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        if contentType == ContentType.movies {
            getPopularMovies(page: self.page)
        } else {
            getPopularTv(page: self.page)
        }
        configureDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController(){
        view.backgroundColor = .systemBackground
        title                = contentType.rawValue
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MostViewedItemCell.self, forCellWithReuseIdentifier: MostViewedItemCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        if contentType == ContentType.movies {
            searchController.searchBar.placeholder              = "Search for a movie"
        } else if contentType == ContentType.tv{
            searchController.searchBar.placeholder              = "Search for a TV show"
        }
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CineparkItem>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, cineparkItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostViewedItemCell.reuseID, for: indexPath) as! MostViewedItemCell
            cell.set(cineparkItem: cineparkItem)
            return cell
        })
    }
    
    func updateData(on results: [CineparkItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CineparkItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(results)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func updateUI(with results: [CineparkItem]) {
        if results.count < 20 { self.hasMoreResults = false }
        self.cineparkItems.append(contentsOf: results)
        self.updateData(on: self.cineparkItems)
    }
    
    
    func getPopularMovies(page: Int){
        if Reachability.isConnectedToNetwork(){
            showLoadingView()
            isLoadingMoreResults = true
            ApiClient.getPopularMovies(page: page)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { response in
                    self.dismissLoadingView()
                    self.isLoadingMoreResults = false
                    if let results = response.cineparkItems {
                        self.updateUI(with: results)
                    }
                }, onError: { error in
                    self.dismissLoadingView()
                    self.isLoadingMoreResults = false
                    
                    switch error {
                    case ApiError.notFound:
                        self.presentCPAlertOnMainThread(title: "Not Found", message: CPError.invalidResponse.rawValue, buttonTitle: "Ok")
                    case ApiError.unauthorized:
                        self.presentCPAlertOnMainThread(title: "Unauthorized !", message: CPError.unauthorized.rawValue, buttonTitle: "Ok")
                    case ApiError.badRequest:
                        self.presentCPAlertOnMainThread(title: "Bad Request", message: CPError.invalidUserInput.rawValue, buttonTitle: "Ok")
                    default:
                        self.presentCPAlertOnMainThread(title: "Invalid Data", message: CPError.invalidData.rawValue, buttonTitle: "Ok")
                    }
                })
                .disposed(by: disposeBag)
        } else {
            self.presentCPAlertOnMainThread(title: "No Internet Connection", message: CPError.unableToComplete.rawValue, buttonTitle: "Ok")
        }
    }
    
    func getPopularTv(page: Int){
        if Reachability.isConnectedToNetwork(){
            showLoadingView()
            isLoadingMoreResults = true
            ApiClient.getPopularTv(page: page)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { response in
                    self.dismissLoadingView()
                    self.isLoadingMoreResults = false
                    if let results = response.cineparkItems {
                        self.updateUI(with: results)
                    }
                    
                }, onError: { error in
                    self.dismissLoadingView()
                    self.isLoadingMoreResults = false
                    
                    switch error {
                    case ApiError.notFound:
                        self.presentCPAlertOnMainThread(title: "Not Found", message: CPError.invalidResponse.rawValue, buttonTitle: "Ok")
                        
                    case ApiError.unauthorized:
                        self.presentCPAlertOnMainThread(title: "Unauthorized !", message: CPError.unauthorized.rawValue, buttonTitle: "Ok")
                        
                    case ApiError.badRequest:
                        self.presentCPAlertOnMainThread(title: "Bad Request", message: CPError.invalidUserInput.rawValue, buttonTitle: "Ok")
                        
                    default:
                        self.presentCPAlertOnMainThread(title: "Invalid Data", message: CPError.invalidData.rawValue, buttonTitle: "Ok")
                    }
                })
                .disposed(by: disposeBag)
        } else {
            self.presentCPAlertOnMainThread(title: "No Internet Connection", message: CPError.unableToComplete.rawValue, buttonTitle: "Ok")
        }
    }
}

extension MoviesAndTvListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreResults, !isLoadingMoreResults else { return }
            page += 1
            if contentType == ContentType.movies {
                getPopularMovies(page: self.page)
            } else {
                getPopularTv(page: self.page)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray     = isSearching ? filteredCineparkItems : cineparkItems
        let cineparkItem    = activeArray[indexPath.item]
        let destVC          = MovieAndTvInfoVC(cineparkItem: cineparkItem, presentation: .modal)
        let navController   = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension MoviesAndTvListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredCineparkItems.removeAll()
            updateData(on: cineparkItems)
            isSearching = false
            return
        }
        
        isSearching = true
        
        if contentType == ContentType.movies {
            filteredCineparkItems = cineparkItems.filter { $0.title!.lowercased().contains(filter.lowercased()) }
            updateData(on: filteredCineparkItems)
        } else if contentType == ContentType.tv {
            filteredCineparkItems = cineparkItems.filter { $0.name!.lowercased().contains(filter.lowercased()) }
            updateData(on: filteredCineparkItems)
        }
    }
}
