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

    var homes:[Home]? {
        didSet {
            
            tableView.reloadData()
        }
    }
    
    var isForSale:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        tableView.register(HomeReportCell.self, forCellReuseIdentifier: "Cell")
        
        let filter = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(onFilter))
        let options = UIBarButtonItem(title: "For Sale", style: .plain, target: self, action: #selector(onOptions))
        navigationItem.rightBarButtonItems = [filter, options]
        
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return homes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HomeReportCell {
            
            let currentHome = homes?[indexPath.item]
                cell.currentHome = currentHome
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentHome = homes?[indexPath.item]
        
        let layout = UICollectionViewFlowLayout()

        let saleHistoryVC = SaleHistoryViewController(collectionViewLayout: layout)
            saleHistoryVC.home = currentHome 
        
        navigationController?.pushViewController(saleHistoryVC, animated: true)
    }
    
    private func loadData() {
        
        Home.getHomeByStatus(isForSale: isForSale, mob: context) { (homes) in
            
            self.homes = homes
        }
    }
    
    @objc
    private func onFilter(sender: UIBarButtonItem) {
        
        
    }
    
    @objc
    private func onOptions(sender: UIBarButtonItem) {
        
        let senderTitle = sender.title
        
        sender.title = senderTitle?.caseInsensitiveCompare("For Sale") == .orderedSame ? "Sold" : "For Sale"
        isForSale = senderTitle?.caseInsensitiveCompare("For Sale") == .orderedSame ? true : false
        
        loadData()
    }
}
