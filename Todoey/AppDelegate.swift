//
//  AppDelegate.swift
//  Todoey
//
//  Created by Frank A Quinn on 2018-12-19.
//  Copyright © 2018 Frank A Quinn. All rights reserved.
//

import UIKit
/*import CoreData....no longer needed*/
import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
/*We will UN-comment the following line when we need to find the filepath*/
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
//        let data = Data()
//        data.name = "Frank"
//        data.age = 65
        
        do {
/*We change this to an underscore because it is not being used right now  ...          let realm = try Realm()*/
     _ = try Realm()
//           try realm.write {
//                realm.add(data)
//            }
        } catch {
            print("Error Initializing new realm, \(error)")
        }
        
        
        
        return true
    }


}

