//
//  String+Date.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/13/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import Timepiece

extension String {
	
	var dateFromInternetFormat: Date? {
		let dateFormatter = ISO8601DateFormatter()
		
		dateFormatter.formatOptions = [ .withInternetDateTime, .withFractionalSeconds ]
		dateFormatter.timeZone = Calendar.timezone
		
		return dateFormatter.date(from: self)
	}
	
}
