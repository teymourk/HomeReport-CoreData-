//
//  SaleHistory+CoreDataClass.swift
//  HomeReport (CoreData)
//
//  Created by Kiarash Teymoury on 6/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import Foundation
import CoreData

@objc(SaleHistory)
public class SaleHistory: NSManagedObject {

    class func getSoldHistory(home:Home, moc:NSManagedObjectContext) -> [SaleHistory] {
        
        let soldHistoryRequest:NSFetchRequest<SaleHistory> = SaleHistory.fetchRequest()
            soldHistoryRequest.predicate = NSPredicate(format: "home = %@", home)
        
        do {
            
            let soldHistory = try moc.fetch(soldHistoryRequest)
            return soldHistory
            
        } catch {
            fatalError("Error Fetching Sale History")
        }
    }
}
