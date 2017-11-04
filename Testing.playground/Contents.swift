//: Playground - noun: a place where people can play

import UIKit

var dateComponents = DateComponents()

dateComponents.year = 2017
dateComponents.month = 11
dateComponents.day = 3
dateComponents.timeZone = TimeZone(abbreviation: "EST")

let date = Calendar.current.date(from: dateComponents)

if date != nil
{
	var weekday = Calendar.current.component(.weekday, from: date!)
	
	if (weekday == 1)
	{
		weekday = 6
	} else
	{
		weekday = weekday - 2;
	}
	
	print(weekday)
}
