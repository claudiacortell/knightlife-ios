//
//  WeekTableViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 12/30/15.
//  Copyright © 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class WeekTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer = Timer()
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var labelsGenerated: Bool = false
    var dayNum: Int = 0
    var numOfRows: Int = 0
    var row: Int = 0
    var labels: [Label] = []
    var cell: BlockTableViewCell = BlockTableViewCell()
    var selectedBlockIndex: Int = 0
    var selectedLabel: Label = Label(bL: "", cN: "", cT: "", c: "")
    let allBlocks: [String] = ["A", "B", "C", "D", "E", "F", "G", "X"]
    
    override func viewDidLoad()
	{
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.items![0].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        self.tabBarController?.tabBar.items![1].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        self.tabBarController?.tabBar.items![2].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WeekTableViewController.generateWeekData), userInfo: nil, repeats: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        var mustGenerateWeekData = false
        
        if(appDelegate.WeekUpdateNeeded){
            mustGenerateWeekData = true
            appDelegate.WeekUpdateNeeded = false
        }
        
        if(appDelegate.transitionFROMsettingtoWeek){
            
            if(!appDelegate.Setting_Updated){
                appDelegate.update_userinfo_things()
                appDelegate.Setting_Updated = true
            }
            appDelegate.transitionFROMsettingtoWeek = false
            mustGenerateWeekData = true
        }
        
        if(mustGenerateWeekData){
            generateWeekData()
        }
        
    }
    
    @IBAction func segControlChanged(_ sender: AnyObject) {
        self.dayNum = segControl.selectedSegmentIndex
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WeekTableViewController.generateWeekData), userInfo: nil, repeats: true)
    }
    
    func generateWeekData() {
        if (appDelegate.Days.count > 0){
            labels = []
            labelsGenerated = false
            checkSecondLunch()
            generateLabels()
            getNumOfRows()
            
            self.tableView.reloadData()
            timer.invalidate()
        }
    }
    
    func checkSecondLunch() {
        
        let defaults = UserDefaults.standard
        var firstLunch_temp: Bool = true
        if defaults.object(forKey: "SwitchValues") != nil {
            let UserSwitch: [Bool] = defaults.object(forKey: "SwitchValues") as! Array<Bool>
            firstLunch_temp = UserSwitch[dayNum]
        }
        
        if(!firstLunch_temp) { // second lunch
            let secondLunchTime = appDelegate.Second_Lunch_Start[dayNum]
            var counter = 0
            var Widget_Block = appDelegate.Widget_Block
            
            for x in Widget_Block[dayNum]{
                if(x.hasSuffix("2")){
                    appDelegate.Days[dayNum].orderedTimes[counter] = secondLunchTime
                    appDelegate.End_Time_Block[dayNum][counter-1] = secondLunchTime
                }
                counter += 1
            }
        }
    }
    
    
    func generateLabels() {
        
        if !labelsGenerated {
            
            for (index, time) in appDelegate.Days[dayNum].orderedTimes.enumerated(){
                
                var blockLetter = ""
                let blockName = appDelegate.Days[dayNum].orderedBlocks[index]
                if blockName == "Lab" {
                    blockLetter = "\(appDelegate.Days[dayNum].orderedBlocks[index - 1])L"
                } else if blockName == "Activities" {
                    blockLetter = "Ac"
                } else {
                    blockLetter = blockName
                }
                
                var classLabel = ""
                let className = appDelegate.Days[dayNum].messagesForBlock[blockName]
                if className == blockLetter {
                    classLabel = "\(blockName) Block"
                } else if blockName == "Lab" {
                    classLabel = "\(appDelegate.Days[dayNum].orderedBlocks[index - 1]) Lab"
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
                
                
                // convert time from military to normal
                let end_time = substring(appDelegate.End_Time_Block[dayNum][index], StartIndex: 1, EndIndex: 3)
                
                var end_time_num:Int! = Int(end_time)
                if(end_time_num > 12){
                    end_time_num = end_time_num! - 12
                }
                
                let regular_hours_end:String! = String(end_time_num)
                let minutes_end = substring(appDelegate.End_Time_Block[dayNum][index],StartIndex: 4,EndIndex: 6)
                let end_time_fin = regular_hours_end + ":" + minutes_end
                let hours = substring(time, StartIndex: 1, EndIndex: 3)
                var hours_num:Int! = Int(hours)
                if(hours_num > 12){
                    hours_num = hours_num! - 12
                }
                let regular_hours:String! = String(hours_num)
                let minutes = substring(time,StartIndex: 4,EndIndex: 6)
                let start_time = regular_hours + ":" + minutes
                
                let time = start_time + " - " + end_time_fin
                
                let newLabel = Label(bL: blockLetter, cN: classLabel, cT: time, c: color)
                labels.append(newLabel)
                
            }
            self.labelsGenerated = true
        }
        
    }
    
    func getNumOfRows() {
        numOfRows = labels.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.numOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (appDelegate.Days.count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Block2TableViewCell
            let label = labels[(indexPath as NSIndexPath).row]
            cell.label = label
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Block2TableViewCell
            let label = Label(bL: "", cN: "", cT: "", c: "999999")
            cell.label = label
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tells the delegate that the specified row is now selected
        selectedLabel = labels[(indexPath as NSIndexPath).row]
        for i in 0 ..< allBlocks.count {
            if allBlocks[i] == selectedLabel.blockLetter || (allBlocks[i] + "L") == selectedLabel.blockLetter || (allBlocks[i] + "1") == selectedLabel.blockLetter || (allBlocks[i] + "2") == selectedLabel.blockLetter {
                selectedBlockIndex = i
                self.performSegue(withIdentifier: "ShowClassNotes", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let noteViewController = segue.destination as! NoteViewController
        let defaults = UserDefaults.standard
        
        let allNames = defaults.object(forKey: "ButtonTexts") as! Array<String>
        if (selectedBlockIndex == 7) {
            noteViewController.classNameStr = "X Block"
        } else {
            noteViewController.classNameStr = allNames[selectedBlockIndex]
            if allNames[selectedBlockIndex] == "" {
                noteViewController.classNameStr = String(selectedLabel.blockLetter.characters.prefix(1)) + " Block"
            }
        }
        let allNotes = defaults.object(forKey: "NoteTexts") as! Array<String>
        noteViewController.classNoteStr = allNotes[selectedBlockIndex]
        let allColors = defaults.object(forKey: "ColorIDs") as! Array<String>
        noteViewController.classColor = hexStringToUIColor(allColors[selectedBlockIndex])
        
        noteViewController.selectedBlockIndex = selectedBlockIndex
        noteViewController.returnSegueIndex = 1
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
    
    func substring(_ origin: String, StartIndex : Int, EndIndex : Int)->String{
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
