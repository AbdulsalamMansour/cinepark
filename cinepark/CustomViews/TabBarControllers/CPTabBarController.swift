//
//  CPTabBarController.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/21/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit

class CPTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = AppColors.primaryViolet
        viewControllers                 = [createMostViewedVC(), createFavoritesNC()]
    }
    
    func createMostViewedVC() -> UINavigationController {
        let mostViewedVC        = MostViewedVC()
        mostViewedVC.title      = "Most Viewed"
        mostViewedVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        
        return UINavigationController(rootViewController: mostViewedVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC         = FavoritesListVC()
        favoritesListVC.title       = "Favorites"
        favoritesListVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesListVC)
    }
}
