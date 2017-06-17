//
//  HomeReportCell.swift
//  HomeReport (CoreData)
//
//  Created by Kiarash Teymoury on 6/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

class HomeReportCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentHome:Home? {
        didSet {
            
            if let images = currentHome?.image, let cityLabel = currentHome?.city, let type = currentHome?.homeType, let beds = currentHome?.bed, let bath = currentHome?.bath, let sqft = currentHome?.sqft, let price = currentHome?.price {
                
                let image = UIImage(data: images as Data)
                houseImage.image = image
                
                typeLabel.text = "\(cityLabel) - \(type)"
                featuresLabel.text = "$\(price) - Beds: \(beds) - Bath: \(bath) - sqft: \(sqft)"
            }
        }
    }
    
    let houseImage:UIImageView = {
        let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.backgroundColor = .red
            image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let typeLabel:UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    let featuresLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView() {
        
        addSubview(houseImage)
        
        houseImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        houseImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        houseImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        houseImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(typeLabel)
        
        typeLabel.topAnchor.constraint(equalTo: houseImage.topAnchor, constant: 5).isActive = true
        typeLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: houseImage.rightAnchor, constant: 15).isActive = true
        
        addSubview(featuresLabel)
        
        featuresLabel.centerYAnchor.constraint(equalTo: houseImage.centerYAnchor).isActive = true
        featuresLabel.leftAnchor.constraint(equalTo: typeLabel.leftAnchor).isActive = true
        featuresLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}
