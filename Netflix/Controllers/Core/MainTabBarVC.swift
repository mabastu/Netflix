//
//  MainTabBarVC.swift
//  Netflix
//
//  Created by Mabast on 2024-08-03.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        homeVC.title = "Home"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        
        let upcomingVC = UINavigationController(rootViewController: UpcomingVC())
        upcomingVC.title = "Upcoming"
        upcomingVC.tabBarItem.image = UIImage(systemName: "play")
        
        let searchVC = UINavigationController(rootViewController: SearchVC())
        searchVC.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let downloadsVC = UINavigationController(rootViewController: DownloadsVC())
        downloadsVC.title = "Downloads"
        downloadsVC.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
        
        tabBar.tintColor = .label
        setViewControllers([homeVC, upcomingVC, searchVC, downloadsVC], animated: true)
    }
}

