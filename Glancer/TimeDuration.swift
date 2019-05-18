//
//  TimeDuration.swift
//  Pods
//
//  Created by Dylan Hanson on 4/15/18.
//

import Foundation
import SwiftyJSON

struct TimeDuration {
	
	let start: Date
	let end: Date
	
}


extension TimeDuration {

	public func duration() -> Int {
		return self.start.minuteDifference(date: self.end)
	}
	
	public func contains(date: Date) -> Bool {
		return date >= self.start && date < self.end
	}
	
}
