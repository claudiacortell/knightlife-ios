//
//  AppDelegate.swift
//  Glancer
//
//  Created by Vishnu Murale on 5/13/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
                
//        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:)))
//		{
//            let types: UIUserNotificationType = ([.alert, .badge, .sound])
//            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
//
//            application.registerUserNotificationSettings(settings)
//            application.registerForRemoteNotifications()
//        }
		
        return true
    }
	
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
	{
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count
		{
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
		
		Device.ID = tokenString
		
		var savedInDB: Bool = false
		if Storage.DB_SAVED.exists()
		{
			savedInDB = Storage.DB_SAVED.getValue() as! Bool
		} else
		{
			Storage.DB_SAVED.set(data: false)
		}

        let tokenStringPub = tokenString
		
//        if (!savedInDB)
//		{
//			Storage.DB_SAVED.set(data: true)
//
//            var request = URLRequest(url: URL(string: "https://bbnknightlife.herokuapp.com/api/deviceTokens/")!)
//            request.httpMethod = "POST"
//            // let postString = "deviceToken=13234323"
//            let postString = "deviceToken=" + tokenStringPub
//            request.httpBody = postString.data(using: .utf8)
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data, error == nil else
//				{                                                 // check for fundamental networking error
//                    print("error=\(error!)")
//                    return
//                }
//
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
//				{           // check for http errors
//                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                    print("response = \(response!)")
//
//                }
//
////                let responseString = String(data: data, encoding: .utf8)
////                print("responseString = \(responseString!)")
//
//            }
//
//            task.resume()
//        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
	{
        print("failed to register for remote notifications: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
	{
        if let aps = userInfo["aps"] as? NSDictionary
		{
            let message: String = aps["alert"] as! String
            
            if (message == "Auto-Updating...")
			{
//                if (ScheduleManager.instance.loadBlocks())
//				{
//                    completionHandler(UIBackgroundFetchResult.newData)
//                }
            }
        }
    }
	
    func applicationWillResignActive(_ application: UIApplication)
	{
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
	{
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
	{
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
	{
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication)
	{
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
	{
//        if (ScheduleManager.instance.loadBlocks())
//		{
//            completionHandler(.newData)
//        } else
//		{
//            completionHandler(.failed)
//        }
    }
}
