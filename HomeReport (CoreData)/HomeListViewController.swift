//
//  ViewController.swift
//  HomeReport (CoreData)
//
//  Created by Kiarash Teymoury on 6/9/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData

class HomeListViewController: UITableViewController {

    lazy var homes = [Home]()
    var isForSale:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.title = "Home Report"
        
        tableView.register(HomeReportCell.self, forCellReuseIdentifier: "Cell")
        
        let filter = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(onFilter))
        let options = UIBarButtonItem(title: "For Sale", style: .plain, target: self, action: #selector(onOptions))
        navigationItem.leftBarButtonItems = [filter, options]
        
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return homes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HomeReportCell {
            
            let currentHome = homes[indexPath.item]
                cell.currentHome = currentHome
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    private func loadData() {
        
        homes = Home.getHomeByStatus(isForSale: isForSale, mob: context)
        tableView.reloadData()
    }
    
    @objc
    private func onFilter(sender: UIBarButtonItem) {
        
        print("SAALAM")
    }
    
    @objc
    private func onOptions(sender: UIBarButtonItem) {
        
        print("HELLO")
    }
}
