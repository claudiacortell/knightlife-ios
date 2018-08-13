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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	
    var window: UIWindow?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		Globals.setData("debug", data: false)
		
		Globals.BundleID = "MAD.BBN.KnightLife"
		Globals.StorageID = "group.KnightLife.MAD.Storage"
		
		Globals.storeUrlBase(url: "https://knightlife-server.herokuapp.com/api/")
				
		UNUserNotificationCenter.current().delegate = self
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
			result, error in
			
			if result {
				print("Successfully authorized notifications")
			} else {
				print("Failed to authorize notifications: \(error != nil ? error!.localizedDescription : "None")")
			}
		}
		
		_ = NotificationManager.instance
		
		_ = TodayManager.instance
		_ = ScheduleManager.instance
		_ = CourseManager.instance
		_ = LunchManager.instance
		_ = EventManager.instance
//		
//		let content = UNMutableNotificationContent()
//		content.title = "Get to Class"
//		content.body = "5 min until English. Room #183."
//		content.sound = UNNotificationSound.default()
//		
//		DispatchQueue.main.async {
//
//		var adjusted = Date.mergeDateAndTime(date: Date.fromWebDate(string: "2018-08-13")!, time: Date.fromWebTime(string: "16-57")!)!
//		adjusted = Calendar.normalizedCalendar.date(byAdding: .minute, value: -1, to: adjusted)!
//
//
//
//		let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.normalizedCalendar.dateComponents([.year, .month, .day, .hour, .minute, .timeZone, .calendar], from: adjusted), repeats: false)
//
//		let unrequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//		UNUserNotificationCenter.current().add(unrequest) {
//			error in
//
//			if error != nil {
//				print("Failed to add notification: \(error!.localizedDescription)")
//			} else {
//
//			}
//		}
//		}
		
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
				print(error.localizedDescription)
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
		completionHandler(UIBackgroundFetchResult.newData)
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
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler(UNNotificationPresentationOptions.alert)
		HapticUtils.NOTIFICATION.notificationOccurred(.success)
	}
	
}
