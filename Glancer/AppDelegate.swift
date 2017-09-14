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
    
    var transitionFROMsettingtoHome: Bool = false; ///coming from settings
    var transitionFROMsettingtoWeek: Bool = false;
    var Setting_Updated : Bool = false;
    
    var WeekUpdateNeeded : Bool = false;
    var Id : String = ""
    var Timer = Foundation.Timer();
	
    var Forced_Update = false; // Needs to update view on shit idk
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
        UIApplication.shared.setMinimumBackgroundFetchInterval(
            UIApplicationBackgroundFetchIntervalMinimum)
                
        // register for Push Notitications, if running iOS 8
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:)))
		{
            let types: UIUserNotificationType = ([.alert, .badge, .sound])
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
	{
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count
		{
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
		
		var savedInDB: Bool = false
		if Storage.DB_SAVED.exists()
		{
			savedInDB = Storage.DB_SAVED.getValue() as! Bool
		} else
		{
			Storage.DB_SAVED.set(data: false)
		}

		print("Device stored in database: \(savedInDB)");

        let tokenStringPub = tokenString
		
        if (!savedInDB)
		{
			Storage.DB_SAVED.set(data: true)
			
            var request = URLRequest(url: URL(string: "https://bbnknightlife.herokuapp.com/api/deviceTokens/")!)
            request.httpMethod = "POST"
            // let postString = "deviceToken=13234323"
            let postString = "deviceToken=" + tokenStringPub
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else
				{                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
				
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
				{           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                
            }
			
            task.resume()
        }
        
        let currentInstallation = PFInstallation.current()
        
        currentInstallation.setDeviceTokenFrom(deviceToken)
        currentInstallation.saveInBackground { (succeeded, e) -> Void in
            // TODO: implement?
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
	{
        print("failed to register for remote notifications:  (error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
	{
        if let aps = userInfo["aps"] as? NSDictionary
		{
            let message: String = aps["alert"] as! String;
            
            if (message == "Auto-Updating...")
			{
                self.Forced_Update = true;
                
                if (ScheduleManager.instance.loadBlocks(true))
				{
                    completionHandler(UIBackgroundFetchResult.newData);
                }
            }
        }
        
        PFPush.handle(userInfo)
    }
    
    func update_userinfo_things() -> Bool{
        // cancel all previous notifications
        let app:UIApplication = UIApplication.shared
        for Event in app.scheduledLocalNotifications! {
            let notification = Event
            app.cancelLocalNotification(notification)
        }
        
        // check if days are already constructed
        if (self.Days.count > 0) {
            self.WeekUpdateNeeded = true; // Week view needs to be updated to reflect the new settings
            setUserValues()
            return true;
        } else {
            // days not yet constructed
            return false;
        }
    }
    
    func setUserValues() {
        let currentDateTime = Days[0].getDateAsString()
        let Day_Num = Days[0].getDayOfWeekFromString(currentDateTime)
        
        var index : Double = 0;
        index = -Double(Day_Num);
        
        /*
         M  T  W  TH  F  SA  SU
         0  1  2  3   4  5   6
         */
        
        let defaults = UserDefaults.standard
        
        // get/set values for class names
        var classNames = [String]()
        if (defaults.object(forKey: "ButtonTexts") != nil) {
            classNames = defaults.object(forKey: "ButtonTexts") as! Array<String>
        } else {
            var count = 0
            while count < 7 {
                classNames.append("")
                count += 1
            }
            defaults.set(classNames, forKey: "ButtonTexts")
        }
        
        // get/set values for lunch boolean settings
        var firstLunches = [Bool]()
        if (defaults.object(forKey: "SwitchValues") != nil) {
            firstLunches = defaults.object(forKey: "SwitchValues") as! Array<Bool>
        } else {
            var count = 0
            while count < 5 {
                firstLunches.append(true)
                count += 1
            }
            defaults.set(firstLunches, forKey: "SwitchValues")
        }
        
        // get/set values for class color selection
        var classColors = [String]()
        if (defaults.object(forKey: "ColorIDs") != nil)
		{
            classColors = defaults.object(forKey: "ColorIDs") as! Array<String>
        } else
		{
//			Default color values
            classColors.append("E74C3C-A")
            classColors.append("E67E22-B")
            classColors.append("F1C40F-C")
            classColors.append("2ECC71-D")
            classColors.append("3498DB-E")
            classColors.append("9B59B6-F")
            classColors.append("DE59B6-G")
            classColors.append("999999-X")
			
            defaults.set(classColors, forKey: "ColorIDs")
        }
        
        // get/set values for class notes
        var classNotes = [String]()
        if (defaults.object(forKey: "NoteTexts") != nil) {
            classNotes = defaults.object(forKey: "NoteTexts") as! Array<String>
        } else {
            var count = 0
            while count < 8 {
                classNotes.append("")
                count += 1
            }
            defaults.set(classNotes, forKey: "NoteTexts")
        }
        
        var dayCounter = 0;
        for day in self.Days {
            
            print("DAY")

            print(dayCounter)
            
            let firstLunch = firstLunches[dayCounter]
            
            for (date, block) in day.timeToBlock {
                
                // stored as mutable b/c of 2nd lunch
                var mutable_date = date;
                
                // block
                var block_copy = block;
                // name of block
                var message = block;
                
                if (block_copy.characters.count == 2) { // E.G. B1 or B2 (Is a lunch block)
                    
                    if (firstLunch && block_copy.hasSuffix("1")) {
                        // first lunch
                        message = "Lunch"
                    } else if (!firstLunch && block_copy.hasSuffix("2")) {
                        // second lunch
                        message = "Lunch"
                        
                        // fire at a different date than the one parse orginally stores
                        let time_of_secondLunch = self.Second_Lunch_Start[dayCounter];
                        mutable_date = Days[0].timeToNSDate(time_of_secondLunch);
                    } else {
                        // regular block
                        
                        // get block letter
                        var counterDigit = 0;
                        for i in block_copy.characters{
                            if (counterDigit == 0) {
                                block_copy = String(i)
                            }
                            counterDigit += 1;
                        }
                    }
                }
                
                if (self.BlockOrder.index(of: block_copy) != nil) {
                    // set block name to user value
                    let indexOfUserInfo = self.BlockOrder.index(of: block_copy)!
                    
                    if (classNames[indexOfUserInfo] != "")
					{
                        message = classNames[indexOfUserInfo]
                    }
                }
                
                // set up notifications
                if (message == "Lunch") {
                    var RegularDate = mutable_date;
                    let localNotification:UILocalNotification = UILocalNotification()
                    localNotification.alertAction = "Knight Life"
                    localNotification.alertBody = message;
                    
                    day.messagesForBlock[block] = message;
                    
                    RegularDate = RegularDate.addingTimeInterval(60 * 60 * 24 * index);
                    
                    print("REGULAR");
                    print(RegularDate as Date);
                    
                    
                    if(!self.Vacation){ //only set notifications if it's not vacation
                    
						let DateScheduled = day.NSDateToString(RegularDate)
						localNotification.fireDate = RegularDate as Date
						localNotification.soundName = UILocalNotificationDefaultSoundName;
						localNotification.repeatInterval = NSCalendar.Unit.weekOfYear
						UIApplication.shared.scheduleLocalNotification(localNotification)
                    
                    }
                    
                    
                    
                    
                } else {
                    var Earlydate = mutable_date.addingTimeInterval(-60*5)
                    
                    let localNotification:UILocalNotification = UILocalNotification()
                    localNotification.alertAction = "Knight Life"
                    localNotification.alertBody = "5 minutes until " + message;
                    
                    day.messagesForBlock[block] = message;
                    
                    Earlydate = Earlydate.addingTimeInterval(60 * 60 * 24 * index)
                    
                    print("EARLY");
                    print(Earlydate as Date);
                    
                    if(!self.Vacation){ //only set notifications if it's not vacation
                    
						let DateScheduled = day.NSDateToString(Earlydate)
						localNotification.fireDate = Earlydate as Date
						localNotification.repeatInterval = NSCalendar.Unit.weekOfYear
						localNotification.soundName = UILocalNotificationDefaultSoundName;
						UIApplication.shared.scheduleLocalNotification(localNotification)
                        
                    }
                }
            }
            dayCounter += 1;
            index += 1;
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication)
	{
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

		Timer.invalidate()
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
        if (ScheduleManager.instance.loadBlocks(true))
		{
            completionHandler(.newData)
        } else
		{
            completionHandler(.failed)
        }
    }
    
}
