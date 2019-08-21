//
//  Calendar+Core.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/24/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation


//creates the calendar? unsure
extension Calendar {
	
	static let normalizedCalendar: Calendar = {
		var calendar = Calendar(identifier: .gregorian)
		
		calendar.locale = Calendar.locale_us
		calendar.timeZone = Calendar.timezone
		
		return calendar
	}()
	
	static let locale_us = Locale(identifier: "en_US_POSIX")
	static let timezone = TimeZone(identifier: "America/New_York")!
	
}
