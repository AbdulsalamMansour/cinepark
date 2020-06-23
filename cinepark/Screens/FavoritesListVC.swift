//
//  FavoritesListVC.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/21/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

class FavoritesListVC: UIViewController {

        let tableView                   = UITableView()
        var favorites: [CineparkItem]   = []

        
        override func viewDidLoad() {
            super.viewDidLoad()
            configureViewController()
            configureTableView()
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            getFavorites()
        }
        
        
        func configureViewController() {
            view.backgroundColor    = .systemBackground
            title                   = "Favorites"
        }
        
        
        func configureTableView() {
            view.addSubview(tableView)
            
            tableView.frame         = view.bounds
            tableView.rowHeight     = 80
            tableView.delegate      = self
            tableView.dataSource    = self
            tableView.removeExcessCells()
            
            tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        }
        
        
        func getFavorites() {
            PersistenceManager.retrieveFavorites { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let favorites):
                    self.updateUI(with: favorites)
                    
                case .failure(let error):
                    self.presentCPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            }
        }
        
        
        func updateUI(with favorites: [CineparkItem]) {
            if favorites.isEmpty {
                self.presentCPAlertOnMainThread(title: "No Favoritess", message: "", buttonTitle: "Ok")
            } else  {
                self.favorites = favorites
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
            }
        }
    }


    extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favorites.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
            let favorite = favorites[indexPath.row]
            cell.set(favorite: favorite)
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let favorite    = favorites[indexPath.row]
            let destVC      = MovieAndTvInfoVC(cineparkItem: favorite, presentation: .navigationController)
            
            navigationController?.pushViewController(destVC, animated: true)
        }
        
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard editingStyle == .delete else { return }
            
            PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    self.favorites.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    return
                }
                
                self.presentCPAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
