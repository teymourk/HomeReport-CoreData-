//
//  CutomeTabBar.swift
//  HomeReport (CoreData)
//
//  Created by Kiarash Teymoury on 6/16/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class CustomeTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barStyle = .default
        
        let homeController = HomeListViewController()
        let homeNav = UINavigationController(rootViewController: homeController)
            homeController.title = "Home"
        
        let saleController = SaleHistoryViewController()
        let saleNav = UINavigationController(rootViewController: saleController)
            saleController.title = "History"
        
        viewControllers = [homeNav, saleNav]
    }
}
