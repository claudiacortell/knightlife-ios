//
//  TimeContainer.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct TimeContainer
{
	var timeString: String!
	
	init(_ timeString: String) { self.timeString = timeString }
}

extension TimeContainer
{
//    func asDate() -> Date
//    {
//        return TimeUtils.timeToNSDate(self.timeString)
//    }
//
//    func toFormattedString() -> String
//    {
//        var hourInt = Int(Utils.substring(timeString, start: 1, distance: 3))!
//        hourInt = hourInt % 12 == 0 ? hourInt : hourInt % 12 // If the hour is 12 let it be, otherwise change to the remainder E.G. 1:30
//        let hour = String(hourInt)
//
//        let minute = Utils.substring(timeString, StartIndex: 4, EndIndex: 6)
//
//        return "\(hour):\(minute)"
//    }
//
//    public static func ==(lhs: TimeContainer, rhs: TimeContainer) -> Bool
//    {
//        return lhs.timeString == rhs.timeString
//    }
}
