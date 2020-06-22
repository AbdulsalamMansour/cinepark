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
    
    var contentType: ContentType!
    private let disposeBag              = DisposeBag()
    
    var results: [Result]               = []
    var filteredResults: [Result]       = []
    
    var page                            = 1
    var hasMoreResults                  = true
    var isLoadingMoreResults            = false
    var isSearching                     = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Result>!
    
    
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
            getMovies(page: self.page)
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
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
        dataSource = UICollectionViewDiffableDataSource<Section, Result>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, result) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostViewedItemCell.reuseID, for: indexPath) as! MostViewedItemCell
            cell.set(result: result)
            return cell
        })
    }
    
    func updateData(on results: [Result]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Result>()
        snapshot.appendSections([.main])
        snapshot.appendItems(results)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func updateUI(with results: [Result]) {
        if results.count < 20 { self.hasMoreResults = false }
        self.results.append(contentsOf: results)
        self.updateData(on: self.results)
    }
    
    
    func getMovies(page: Int){
        showLoadingView()
        isLoadingMoreResults = true
        ApiClient.getPopularMovies(page: page)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                self.dismissLoadingView()
                self.isLoadingMoreResults = false
                if let results = response.results {
                    self.updateUI(with: results)
                }
            }, onError: { error in
                self.dismissLoadingView()
                self.isLoadingMoreResults = false
                print("error ----------------------")
            })
            .disposed(by: disposeBag)
    }
    
    func getPopularTv(page: Int){
        showLoadingView()
        isLoadingMoreResults = true
        ApiClient.getPopularTv(page: page)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                self.dismissLoadingView()
                self.isLoadingMoreResults = false
                if let results = response.results {
                    self.updateUI(with: results)
                }
                
            }, onError: { error in
                self.dismissLoadingView()
                self.isLoadingMoreResults = false
                
            })
            .disposed(by: disposeBag)
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
                getMovies(page: self.page)
            } else {
                getPopularTv(page: self.page)
            }
            
        }
    }
}

extension MoviesAndTvListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredResults.removeAll()
            updateData(on: results)
            isSearching = false
            return
        }
        
        isSearching = true
        
        if contentType == ContentType.movies {
            filteredResults = results.filter { $0.title!.lowercased().contains(filter.lowercased()) }
            updateData(on: filteredResults)
        } else if contentType == ContentType.tv {
            filteredResults = results.filter { $0.name!.lowercased().contains(filter.lowercased()) }
            updateData(on: filteredResults)
        }
    }
}
