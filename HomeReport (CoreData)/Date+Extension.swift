//
//  Date+Extension.swift
//  HomeReport (CoreData)
//
//  Created by Kiarash Teymoury on 6/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import Foundation

extension Date {
    
    var toString:String {
        let dataFormatter = DateFormatter()
            dataFormatter.dateStyle = .medium
        
        return dataFormatter.string(from: self)
    }
}
