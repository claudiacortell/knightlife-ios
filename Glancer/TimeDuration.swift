//
//  TimeDuration.swift
//  Pods
//
//  Created by Dylan Hanson on 4/15/18.
//

import Foundation

struct TimeDuration {
	
	let start: Date
	let end: Date
	
	public init(start: Date, end: Date) {
		self.start = start
		self.end = end
	}
	
}


extension TimeDuration {

	public func duration() -> (hours: Int, minutes: Int, seconds: Int) {
		return (hours: abs(self.start.hour - self.end.hour), minutes: abs(self.start.minute - self.end.minute), seconds: abs(self.start.second - self.end.second))
	}
	
}
