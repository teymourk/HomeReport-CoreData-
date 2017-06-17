//
//  Home+CoreDataClass.swift
//  HomeReport (CoreData)
//
//  Created by Kiarash Teymoury on 6/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import Foundation
import CoreData

@objc(Home)
public class Home: NSManagedObject {
    
    typealias HomeByStatusHandler = (_ homes: [Home]) -> Void
    
    class func getHomeByStatus(isForSale:Bool, mob: NSManagedObjectContext, completionHandle: @escaping HomeByStatusHandler) {
        
        let request:NSFetchRequest<Home> = Home.fetchRequest()
        request.predicate = NSPredicate(format: "isForSale = %@", isForSale as CVarArg)
        
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { (results: NSAsynchronousFetchResult<Home>) in
            
            if let homes = results.finalResult {
                
                completionHandle(homes)
            }
        }
        
        do {
            
            try mob.execute(asyncRequest)
            
        } catch {
            fatalError("Error in getting list of homes")
        }
    }
}
