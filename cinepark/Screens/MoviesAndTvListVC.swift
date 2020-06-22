//
//  MoviesListVC.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/21/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit
import RxSwift

class MoviesAndTvListVC: UIViewController {
    
    enum Section { case main }
    
    var contentType: ContentType!
    
    private let disposeBag = DisposeBag()
    var results: [Result] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Result>!
    
    
    init(contentType: ContentType) {
        super.init(nibName: nil, bundle: nil)
        self.contentType   = contentType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        
        if contentType == ContentType.movies {
            getMovies()
        } else {
            getPopularTv()
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
    
    func getMovies(){
        ApiClient.getPopularMovies()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in

                if let results = response.results {
                    self.updateData(on: results)
                }
            }, onError: { error in
                print("error ----------------------")
            })
            .disposed(by: disposeBag)
    }
    
    func getPopularTv(){
        ApiClient.getPopularTv()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in

                if let results = response.results {
                    self.updateData(on: results)
                }
            }, onError: { error in
                print("error ----------------------")
            })
            .disposed(by: disposeBag)
    }
}

extension MoviesAndTvListVC: UICollectionViewDelegate {
    
}
