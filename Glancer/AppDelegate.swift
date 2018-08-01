//
//  AppDelegate.swift
//  Glancer
//
//  Created by Vishnu Murale on 5/13/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit
import Alamofire
import AddictiveLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
    var window: UIWindow?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		Globals.BundleID = "MAD.BBN.KnightLife"
		Globals.StorageID = "MAD.BBN.KnightLife.Storage"
		
		Globals.storeUrlBase(url: "https://knightlife-server.herokuapp.com/api/")
		
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
		
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:)))
		{
            let types: UIUserNotificationType = ([.alert, .badge, .sound])
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)

            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
		
		_ = TodayManager.instance
		_ = ScheduleManager.instance
		_ = CourseManager.instance
		_ = LunchManager.instance
		_ = EventManager.instance
		
        return true
    }
	
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
		Globals.DeviceID = tokenString
		
		RegistrationWebCall().callback() {
			result in
			
			switch result {
			case .failure(let error):
				print(error)
			case .success(_):
				break
			}
		}.execute()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		if let aps = userInfo as? [String: Any], let type = aps["type"] as? Int {
			if type == 0 {
//				ScheduleManager.instance.reloadAllSchedules()
			}
		}
    }
	
    func applicationWillResignActive(_ application: UIApplication) {
		TodayManager.instance.stopTimer()
	}
    
    func applicationDidEnterBackground(_ application: UIApplication){
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
		TodayManager.instance.startTimer()
	}
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//		LOAD BLOCKS
    }
}
