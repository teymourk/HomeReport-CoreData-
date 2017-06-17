//
//  SaleHistory.swift
//  HomeReport (CoreData)
//
//  Created by Kiarash Teymoury on 6/16/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData

class SaleHistoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var soldHistory:[SaleHistory]? {
        didSet {
            
            collectionView?.reloadData()
        }
    }
    
    var home:Home?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(SaleHistoryCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(SaleHistoryHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "cellHeader")
        collectionView?.backgroundColor = .white
        
        self.title = "Sale History"
        
        loadSoldHistoy()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return soldHistory?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SaleHistoryCell {
            
            let saleHistory = soldHistory?[indexPath.item]
            
            cell.saleDetails = saleHistory
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 40)
    }
    
    //Mark: Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "cellHeader", for: indexPath) as? SaleHistoryHeader {
            
            if let homeImage = home?.image {
                
                let image = UIImage(data: homeImage as Data)
                header.houseImage.image = image
            }
            
            return header
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 100,
                            left: 0, bottom: 0, right: 0)
    }
    
    private func loadSoldHistoy() {
    
        soldHistory = SaleHistory.getSoldHistory(home: home!, moc: context)
    }
}
class SaleHistoryCell: UICollectionViewCell {
    
    var saleDetails:SaleHistory? {
        didSet {
            
            if let _price = saleDetails?.soldPrice, let _date = saleDetails?.soldDate as Date? {
                
                date.text = "$\(_price) \t \t \t \t \(_date.toString)"
            }
        }
    }
    
    let date:UILabel = {
        let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(date)
        
        date.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        date.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SaleHistoryHeader: UICollectionViewCell {
    
    let houseImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(houseImage)
        
        houseImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        houseImage.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
