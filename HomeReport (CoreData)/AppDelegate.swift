//
//  AppDelegate.swift
//  HomeReport (CoreData)
//
//  Created by Kiarash Teymoury on 6/9/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let tabBar = CustomeTabBar()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: tabBar)
        
        deleteRecord()
        checkDataStore()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataStack.coreData.saveContext()
    }
    
    private func checkDataStore() {
        
        let request: NSFetchRequest<Home> = Home.fetchRequest()
        
        do {
            
            let homeCount = try context.count(for: request)
            
            if homeCount == 0 {
                uploadSampleData()
            }
            
        } catch {
            
            fatalError("Error in Counting Home Record")
        }
    }
    
    private func uploadSampleData() {
        
        let context = CoreDataStack.coreData.persistentContainer.viewContext
     
        if let url = Bundle.main.url(forResource: "homes", withExtension: "json"), let data = try? Data(contentsOf: url) {
            
            do {
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary, let jsonArray = jsonResult.value(forKey: "home") as? NSArray {
                   
                    for json in jsonArray {
                        
                        if let homeData = json as? [String: AnyObject] {
                            
                            var image:UIImage?
                            
                            guard let city = homeData["city"] as? String else {return}
                            guard let price = homeData["price"] as? Double else {return}
                            guard let bed = homeData["bed"] else {return}
                            guard let bath = homeData["bath"] else {return}
                            guard let sqft = homeData["sqft"] else {return}
                            guard let homeCategory = homeData["category"] as? NSDictionary, let homeType = homeCategory["homeType"] as? String else {return}
                            guard let homeStatus = homeData["status"] as? NSDictionary, let isForSale = homeStatus["isForSale"] as? Bool else {return}
                            
                            if let currentImage = homeData["image"], let imageName = currentImage as? String {
                                
                                image = UIImage(named: imageName)
                            }
                            
                            //HomeObject Initializing
                            let home = homeType.caseInsensitiveCompare("condo") == .orderedSame ? Condo(context: context) : SingleFamily(context: context)
                                home.price = price
                                home.bed = bed.int16Value
                                home.bath = bath.int16Value
                                home.sqft = sqft.int16Value
                                home.image = NSData(data: UIImageJPEGRepresentation(image!, 1.0)!)
                                home.homeType = homeType
                                home.city = city
                                home.isForSale = isForSale
                            
                            if let unitsPerBuilding = homeData["unitsPerBuilding"] {
                                
                                (home as! Condo).unitsPerBuilding = unitsPerBuilding.int16Value
                            }
                            
                            if let lotSize = homeData["lotSize"] {
                                (home as! SingleFamily).lotSize = lotSize.int16Value
                            }
                            
                            if let saleHistory = homeData["saleHistory"] as? NSArray, let saleHistoryData = home.saleHistory?.mutableCopy() as? NSMutableSet {
                                
                                for saleDetail in saleHistory {
                                    
                                    if let saleData = saleDetail as? [String: AnyObject] {
                                        
                                        guard let soldPrice = saleData["soldPrice"] as? Double else {return}
                                        guard let soldDateStr = saleData["soldDate"] as? String else {return}
                                        
                                        let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd"
                                        
                                        let soldDate = dateFormatter.date(from: soldDateStr)! as NSDate
                                        
                                        let saleHistory = SaleHistory(context: context)
                                            saleHistory.soldPrice = soldPrice
                                            saleHistory.soldDate = soldDate
                                        
                                        saleHistoryData.add(saleHistory)
                                
                                        home.addToSaleHistory(saleHistory)
                                    }
                                }
                            }
                        }
                    }
                }
                
                CoreDataStack.coreData.saveContext()
                
            } catch {
                fatalError("Cannot Upload Sample Data")
            }
        }
    }
    
    func deleteRecord() {
        
        let context = CoreDataStack.coreData.persistentContainer.viewContext
        
        let homeRequest:NSFetchRequest<Home> = Home.fetchRequest()
        let saleHistoryRequest:NSFetchRequest<SaleHistory> = SaleHistory.fetchRequest()
        
        var deleteRequest:NSBatchDeleteRequest
        var deleteResults:NSPersistentStoreResult
        
        do {
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: homeRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try context.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: saleHistoryRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try context.execute(deleteRequest)
            
            
        } catch {
            
            fatalError("Failed To Remove Exisitng Record")
        }
    }
}

let context = CoreDataStack.coreData.persistentContainer.viewContext
