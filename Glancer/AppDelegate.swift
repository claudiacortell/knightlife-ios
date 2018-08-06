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
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
    var window: UIWindow?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		Globals.BundleID = "MAD.BBN.KnightLife"
		Globals.StorageID = "MAD.BBN.KnightLife.Storage"
		
		Globals.storeUrlBase(url: "https://knightlife-server.herokuapp.com/api/")
		
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
			result, error in
			
			if result {
				print("Successfully authorized notifications")
			} else {
				print("Failed to authorize notifications: \(error != nil ? error!.localizedDescription : "None")")
			}
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
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		PushNotificationManager.instance.handle(payload: userInfo)
    }
	
	func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
		ScheduleManager.instance.clearCache()
		LunchManager.instance.clearCache()
		EventManager.instance.clearCache()
	}
	
    func applicationWillResignActive(_ application: UIApplication) {
		TodayManager.instance.stopTimer()
	}
    
    func applicationDidEnterBackground(_ application: UIApplication){
		
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {

	}
    
    func applicationDidBecomeActive(_ application: UIApplication) {
		TodayManager.instance.startTimer()
	}
	
}
