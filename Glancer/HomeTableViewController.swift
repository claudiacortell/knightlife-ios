//
//  HomeTableViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 11/29/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, ScheduleUpdateHandler, PrefsUpdateHandler
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer = Timer()
    var timer2 = Timer()
    @IBOutlet weak var mainDayLabel: UILabel!
    @IBOutlet weak var mainBlockLabel: UILabel!
    @IBOutlet weak var mainTimeLabel: UILabel!
    @IBOutlet weak var mainNextBlockLabel: UILabel!
    
    var localizedDayOfWeekFuckMeOmfg: Int = 0 // Day of week
    var numOfRows: Int = 0
    var row: Int = 0
    var minutesUntilNextBlock: Int = 0
    var labels: [Label] = []
    var cell: BlockTableViewCell = BlockTableViewCell()
    var selectedBlockIndex: Int = 0
    var selectedLabel: Label = Label(bL: "", cN: "", cT: "", c: "")
    let allBlocks: [String] = ["A", "B", "C", "D", "E", "F", "G", "X"]
    
    var labelsGenerated: Bool = false
	
	var scheduleUpdated = false
	var settingsUpdated = false
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
        
        _ = ScheduleManager.instance.loadBlocks()
            
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeTableViewController.generateHomeScreenData), userInfo: nil, repeats: true)
		
		self.tabBarController?.tabBar.items![0].isEnabled = false
		self.tabBarController?.tabBar.items![0].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
		self.tabBarController?.tabBar.items![1].isEnabled = false
		self.tabBarController?.tabBar.items![1].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
		self.tabBarController?.tabBar.items![2].isEnabled = false
		self.tabBarController?.tabBar.items![2].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(appDelegate.transitionFROMsettingtoHome){
            if(!appDelegate.Setting_Updated){
                appDelegate.update_userinfo_things()
                appDelegate.Setting_Updated = true
            }
            appDelegate.transitionFROMsettingtoHome = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
	{
        ScheduleManager.instance.loadBlocks()
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeTableViewController.generateHomeScreenData), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func scheduleDidUpdate(didUpdateSuccessfully: Bool, newSchedule: inout [DayID: Weekday])
	{
		self.scheduleUpdated = didUpdateSuccessfully
	}
	
	func prefsDidUpdate(manager: UserPrefsManager)
	{
		self.settingsUpdated = true
	}
    
    func generateHomeScreenData()
	{
        if (ScheduleManager.instance.onVacation)
		{
            mainDayLabel.text = "Vacation"
            mainBlockLabel.text = "Enjoy"
            mainTimeLabel.text = ""
            mainNextBlockLabel.text = ""
            
            labels = []
            self.labelsGenerated = false
            generateLabels()
            getNumOfRows()
            self.tableView.reloadData()
            self.tabBarController?.tabBar.items![0].isEnabled = true
            self.tabBarController?.tabBar.items![1].isEnabled = true
            self.tabBarController?.tabBar.items![2].isEnabled = true
            timer.invalidate()
        } else if (appDelegate.Days.count > 0)
		{
            updateMainHomePage()
            
            if localizedDayOfWeekFuckMeOmfg < 5
			{
                checkSecondLunch()
            }
            
            labels = []
            self.labelsGenerated = false
            generateLabels()
            getNumOfRows()
            self.tableView.reloadData()
            self.tabBarController?.tabBar.items![0].isEnabled = true
            self.tabBarController?.tabBar.items![1].isEnabled = true
            self.tabBarController?.tabBar.items![2].isEnabled = true
            timer.invalidate()
        }
        
    }
    
    func updateMainHomePage() {
        //updates the main labels on home page
        mainDayLabel.text = getMainDayLabel()
        mainBlockLabel.text = getMainBlockLabel()
        mainTimeLabel.text = getMainTimeLabel()
        mainNextBlockLabel.text = getMainNextBlockLabel()
    }
    
    
    // get Home Page labels
    func getMainDayLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDateAsString()
        let dayNum = appDelegate.Days[0].getDayOfWeekFromString(currentDateTime)
        self.localizedDayOfWeekFuckMeOmfg = dayNum
        if dayNum == 5 {
            return "Saturday"
        } else if dayNum == 6 {
            return "Sunday"
        } else {
            return appDelegate.Days[dayNum].name
        }
    }
    
    func getMainBlockLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDateAsString()
        let dayNum = appDelegate.Days[0].getDayOfWeekFromString(currentDateTime)
        
        if dayNum < 5 {
            let currentValues = getCurrentDayInformation()
            let currentBlock = currentValues.currentBlock
            let currentClass = appDelegate.Days[dayNum].messagesForBlock[currentBlock]
            if currentClass != nil {
                if currentBlock == "X" {
                    return "\(currentBlock) Block"
                } else if currentBlock == "Activities" || currentBlock == "Lab" {
                    return "\(currentBlock)"
                } else {
                    return "\(currentBlock) Block (\(currentClass!))"
                }
            } else if currentBlock == "GetToClass" {
                return "Class Over"
            }
            else if currentBlock == "BeforeSchoolGetToClass"{
                return "School Begins"
            }
            else {
                return ""
            }
        } else {
            return ""
        }
        
    }
    
    func getMainTimeLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDateAsString()
        let dayNum = appDelegate.Days[0].getDayOfWeekFromString(currentDateTime)
        
        if dayNum < 5 {
            let currentValues = getCurrentDayInformation()
            let currentBlock = currentValues.currentBlock
            let currentClass = appDelegate.Days[dayNum].messagesForBlock[currentBlock]
            if currentClass != nil {
                let minutesRemaining = currentValues.minutesRemaining
                return "\(minutesRemaining) mins remaining"
            } else if currentBlock == "GetToClass" ||  currentBlock == "BeforeSchoolGetToClass"{
                let minutesRemaining = currentValues.minutesRemaining
                let minutesUntil = 5 - (-minutesRemaining)
                return "\(minutesUntil) mins until"
            } else if currentBlock == "BeforeSchool"{
                return "Before School"
            }else{
                return "School Over"
            }
        } else {
            return "No School"
        }
    }
    
    func getMainNextBlockLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDateAsString()
        let dayNum = appDelegate.Days[0].getDayOfWeekFromString(currentDateTime)
        
        if dayNum < 5 {
            let currentValues = getCurrentDayInformation()
            let currentBlock = currentValues.currentBlock
            let nextBlock = currentValues.nextBlock
            let nextClass = appDelegate.Days[dayNum].messagesForBlock[nextBlock]
            if nextClass != nil {
                if nextClass == "X" {
                    return "Next: \(nextClass!) Block"
                } else if nextClass == "Activities" || nextClass == "Lab" {
                    return "Next: \(nextClass!)"
                } else {
                    return "Next: \(nextBlock) Block (\(nextClass!))"
                }
            } else if currentBlock == "GetToClass" {
                //return "Next Block"
            } else {
                return ""
            }
        } else {
            return ""
        }
        return ""
    }
    
    
    func checkSecondLunch() {
        
        // get info for the first lunch data for today
        let defaults = UserDefaults.standard
        print("SDLFKJSD:LFKJSDL:FJKs")
        print(defaults)
        var firstLunchTemp: Bool = true
        if defaults.object(forKey: "SwitchValues") != nil {
            let UserSwitch: [Bool] = defaults.object(forKey: "SwitchValues") as! Array<Bool>
            firstLunchTemp = UserSwitch[localizedDayOfWeekFuckMeOmfg]
        }
        
        // we change the time's array to reflect the second lunch when applicable
        if(!firstLunchTemp) { //aka second lunch
            
            let secondLunchTime = appDelegate.Second_Lunch_Start[dayNum]
            var counter = 0
            var widgetBlock = appDelegate.Widget_Block
            
            for x in widgetBlock[dayNum]{
                if(x.hasSuffix("2")){
                    appDelegate.Days[dayNum].orderedTimes[counter] = secondLunchTime
                    appDelegate.End_Time_Block[dayNum][counter-1] = secondLunchTime
                }
                counter += 1
            }
        }
    }
    
    func generateLabels() {
        //generates array of information for each cell
        if !labelsGenerated {
            if localizedDayOfWeekFuckMeOmfg < 5 {
                if !ScheduleManager.instance.onVacation
				{
                    
                    for (index, time) in appDelegate.Days[localizedDayOfWeekFuckMeOmfg].orderedTimes.enumerated(){
                        
                        var blockLetter = ""
                        let blockName = appDelegate.Days[localizedDayOfWeekFuckMeOmfg].orderedBlocks[index]
                        if blockName == "Lab" {
                            blockLetter = "\(appDelegate.Days[localizedDayOfWeekFuckMeOmfg].orderedBlocks[index - 1])L"
                        } else if blockName == "Activities" {
                            blockLetter = "Ac"
                        } else {
                            blockLetter = blockName
                        }
                        
                        var classLabel = ""
                        let className = appDelegate.Days[localizedDayOfWeekFuckMeOmfg].messagesForBlock[blockName]
                        if className == blockLetter {
                            classLabel = "\(blockName) Block"
                        } else if blockName == "Lab" {
                            classLabel = "\(appDelegate.Days[localizedDayOfWeekFuckMeOmfg].orderedBlocks[index - 1]) Lab"
                        } else {
                            classLabel = className!
                        }
                        
                        var color = ""
                        let defaults = UserDefaults.standard
                        let UserColor: [String] = defaults.object(forKey: "ColorIDs") as! Array<String>
                        if blockLetter == "A" || blockLetter == "A1" || blockLetter == "A2" || blockLetter == "AL" {
                            color = UserColor[0]
                        } else if blockLetter == "B" || blockLetter == "B1" || blockLetter == "B2" || blockLetter == "BL" {
                            color = UserColor[1]
                        } else if blockLetter == "C" || blockLetter == "C1" || blockLetter == "C2" || blockLetter == "CL" {
                            color = UserColor[2]
                        } else if blockLetter == "D" || blockLetter == "D1" || blockLetter == "D2" || blockLetter == "DL" {
                            color = UserColor[3]
                        } else if blockLetter == "E" || blockLetter == "E1" || blockLetter == "E2" || blockLetter == "EL" {
                            color = UserColor[4]
                        } else if blockLetter == "F" || blockLetter == "F1" || blockLetter == "F2" || blockLetter == "FL" {
                            color = UserColor[5]
                        } else if blockLetter == "G" || blockLetter == "G1" || blockLetter == "G2" || blockLetter == "GL" {
                            color = UserColor[6]
                        } else {
                            color = "999999"
                        }
                        
                        //time is in the form of string, in military time, so the following converts it to a regular looking time
                        
                        let endTime = substring(appDelegate.End_Time_Block[dayNum][index], StartIndex: 1, EndIndex: 3)

                        var endTimeNum:Int! = Int(endTime)
                        if(endTimeNum > 12){
                            endTimeNum = endTimeNum! - 12
                        }
                        
                        let regularHoursEnd:String! = String(endTimeNum)
                        let minutesEnd = substring(appDelegate.End_Time_Block[dayNum][index],StartIndex: 4,EndIndex: 6)

                        let endTimeFinal = regularHoursEnd + ":" + minutesEnd

                        let hours = substring(time, StartIndex: 1, EndIndex: 3)
                        var hoursNum:Int! = Int(hours)
                        if(hoursNum > 12){
                            hoursNum = hoursNum! - 12
                        }
                        let regularHours:String! = String(hoursNum)
                        let minutes = substring(time,StartIndex: 4,EndIndex: 6)
                        let startTime = regularHours + ":" + minutes
                        
                        let time = startTime + " - " + endTimeFinal
                        
                        let newLabel = Label(bL: blockLetter, cN: classLabel, cT: time, c: color)
                        labels.append(newLabel)
                        
                    }
                    
                    self.labelsGenerated = true
                }
            }
        }
        
    }
    
    func findMinutes(_ hourBefore : Int, hourAfter : Int)->Int{
        let numHoursLess = Int(hourBefore/100)
        let numHoursMore = Int(hourAfter/100)
        
        let diffHours = numHoursMore - numHoursLess
        let diffMinutes = hourAfter%100 - hourBefore%100
        
        return diffHours*60 + diffMinutes
    }
    
    func getCurrentDayInformation() -> (currentBlock : String, nextBlock : String, minutesRemaining : Int){
        
        let currentDateTime = appDelegate.Days[0].getDateAsString()
        let dayNum = appDelegate.Days[0].getDayOfWeekFromString(currentDateTime)
        var widgetBlock = appDelegate.Widget_Block
        var timeBlock = appDelegate.Time_Block
        var endTimes = appDelegate.End_Times
        var endTimesBlock = appDelegate.End_Time_Block
        
        var currentBlock = ""
        var nextBlock = ""
        
        var minutesUntilNextBlock = 0
        
        let defaults = UserDefaults.standard
        
        var firstLunchTemp = true
        
        if(defaults.object(forKey: "SwitchValues") != nil){
            let UserSwitch: [Bool] = defaults.object(forKey: "SwitchValues") as! Array<Bool>
            firstLunchTemp = UserSwitch[dayNum]
        }
        
        if(!firstLunchTemp){
            
            let secondLunchTime = appDelegate.Second_Lunch_Start[dayNum]
            var counter = 0
            
            for x in widgetBlock[dayNum]{
                if(x.hasSuffix("2")){
                    timeBlock[dayNum][counter] = secondLunchTime
                    endTimesBlock[dayNum][counter-1] = secondLunchTime
                }

                counter += 1
            }
        }
        
        for i in Array((0...widgetBlock[dayNum].count-1).reversed()){
            
            let dateAfter = timeBlock[dayNum][i]
            let CurrTime = appDelegate.Days[0].NSDateToStringWidget(Date())
            
            let endTimeString = endTimesBlock[dayNum][i]
            
            var hour4 = self.substring(dateAfter,StartIndex: 1,EndIndex: 3)
            hour4 = hour4 + self.substring(dateAfter,StartIndex: 4,EndIndex: 6)
            
            var hour2 = self.substring(CurrTime,StartIndex: 1,EndIndex: 3)
            hour2 = hour2 + self.substring(CurrTime,StartIndex: 4,EndIndex: 6)
            var end_time = self.substring(endTimeString,StartIndex: 1,EndIndex: 3)
            end_time = end_time + self.substring(endTimeString,StartIndex: 4,EndIndex: 6)
            
            
            let hourOne = Int(hour4)
            let hourTwo = Int(hour2)
            let hourAfter = Int(end_time)
        
            if(i==0 && hourTwo < hourOne ){ // if before school
                currentBlock = "BeforeSchool"
                nextBlock = widgetBlock[dayNum][i]

                minutesUntilNextBlock = self.findMinutes(hourTwo!, hourAfter: (hourOne!))
 
                if(minutesUntilNextBlock <= 5){
                    
                    minutesUntilNextBlock = -5+minutesUntilNextBlock
                    currentBlock = "BeforeSchoolGetToClass"
                    nextBlock = widgetBlock[dayNum][i]
 
                }
            }
            
            //last block
            if(i == widgetBlock[dayNum].count-1 && hourTwo >= hourOne){
                
                let EndTime = endTimes[dayNum]
                if(hourTwo! - EndTime < 0) {

                    minutesUntilNextBlock = self.findMinutes(hourTwo!, hourAfter: (EndTime))
                    
                    if(minutesUntilNextBlock > 0){
                        currentBlock = widgetBlock[dayNum][i]
                        nextBlock = "No Class"
                    }
                    else {
                        currentBlock = "GetToClass"
                        nextBlock = widgetBlock[dayNum][i]
                    }
                }
                else {
                    currentBlock = "NOCLASSNOW"
                    nextBlock = "No Class"
                    
                }
                break
            }
            
            
            if(hourTwo >= hourOne){
                minutesUntilNextBlock = self.findMinutes(hourTwo!, hourAfter: (hourAfter!))
                
                if(minutesUntilNextBlock > 0){
                    currentBlock = widgetBlock[dayNum][i]
                    nextBlock = widgetBlock[dayNum][i + 1]
                }
                else{
                    currentBlock = "GetToClass"
                    nextBlock = widgetBlock[dayNum][i + 1]
                }
                break
            }
            
        }
        return (currentBlock, nextBlock, minutesUntilNextBlock)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.numOfRows
    }
    
    func getNumOfRows() {
        //finds number of rows in table
        numOfRows = labels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creates cells
        if (appDelegate.Days.count > 0)
		{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BlockTableViewCell
            let label = labels[(indexPath as NSIndexPath).row]
            cell.label = label
            
            return cell
        } else
		{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BlockTableViewCell
            let label = Label(bL: "", cN: "", cT: "", c: "999999")
            cell.label = label
            
            return cell
        }
        
    }
	
    func hexStringToUIColor (_ hex: String) -> UIColor {
        let cString = self.substring(hex, StartIndex: 0, EndIndex: 6)
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func substring(_ origin :String, StartIndex : Int, EndIndex : Int)->String{
        var counter = 0
        var subString = ""
        for char in origin.characters{
            
            if(StartIndex <= counter && counter < EndIndex){
                subString += String(char)
            }
            counter += 1
        }
        return subString
    }
}
