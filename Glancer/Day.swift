//
//  Day.swift
//  Glancer
//
//  Created by Vishnu Murale on 5/15/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import Foundation


open class Day: NSObject {
    
    var name: String = "";
    var timeToBlock = [Date: String]()
    var orderedBlocks = [String]();
    var orderedTimes = [String]();
    
    var messagesForBlock = [String : String]();
    
    init(name: String){
        self.name = name;
    }
    
    func getDateAsString() -> String{
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.month, .year, .day], from: date)
        
        let month = components.month
        let year = components.year
        let day = components.day
        
        var monthString = String(describing: month!)
        if(monthString.characters.count == 1){
            monthString = "0" + monthString
        }
        
        var outDate = String(describing: year!) + "-"
        outDate += monthString
        outDate += "-" + String(describing: day!)
  
        return outDate
    }
    
    func refreshDay(_ block_order: Array<String>, times: Array<String>){
        for index in 0...(times.count-1){
            orderedBlocks.append(block_order[index]);
            orderedTimes.append(times[index]);
            let block = block_order[index]
            let time = times[index]
            let timerDate = timeToNSDate(time)
            timeToBlock[timerDate] = block
        }
        
    }
    
    func timeToNSDate(_ time: String)->Date {
        var currentDate = getDateAsString()
        let formatter  = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "yyyy-MM-dd-HH-mm"
        currentDate+=time;

        let outDate = formatter.date(from: currentDate)!
        return outDate;
    }
    
    
    func NSDateToString(_ time: Date)->String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.month, .year, .day, .hour, .minute], from: time)
        
        let month = components.month
        let year = components.year
        let day = components.day
        let hour = components.hour
        
        let minute = components.minute
        
        var monthString = String(describing: month)
        if(monthString.characters.count == 1){
            monthString = "0" + monthString
        }
        var hourString = String(describing: hour)
        if(hourString.characters.count == 1){
            hourString = "0" + hourString
        }
        var minuteString = String(describing: minute)
        if(minuteString.characters.count == 1){
            minuteString = "0" + minuteString
        }
        
        var outDate = String(describing: year) + "-"
        outDate += monthString
        outDate += "-" + String(describing: day)
        outDate += "-" + hourString
        outDate += "-" + minuteString
        
        return outDate
    }
    
    
    func NSDateToStringWidget(_ time: Date)->String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.month, .year, .day, .hour, .minute], from: time)
        
        let hour = components.hour!
        let minute = components.minute!
        
        var hourString = String(describing: hour)
        if(hourString.characters.count == 1){
            hourString = "0" + hourString
        }
        var minuteString = String(describing: minute)
        if(minuteString.characters.count == 1){
            minuteString = "0" + minuteString
        }
        
        var outDate = "-"
        outDate += hourString
        outDate += "-" + minuteString
                
        return outDate
    }

    func getDayOfWeekFromString(_ today:String)->Int {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
        var weekDay = myComponents.weekday
        
        if(weekDay == 1){
            weekDay = 6
        }
        else{
            weekDay = weekDay! - 2;
        }
        
        return weekDay!
    }
    
}
