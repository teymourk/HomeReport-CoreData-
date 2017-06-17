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
    
    class func getHomeByStatus(isForSale:Bool, mob: NSManagedObjectContext) -> [Home] {
        
        let request:NSFetchRequest<Home> = Home.fetchRequest()
        request.predicate = NSPredicate(format: "isForSale = %@", isForSale as CVarArg)
        
        do {
            
            let homes = try mob.fetch(request)
            
            print(homes.count)
            
            return homes
            
        } catch {
            fatalError("Error in getting list of homes")
        }
    }
}
