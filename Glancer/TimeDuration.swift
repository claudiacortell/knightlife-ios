//
//  TimeDuration.swift
//  Pods
//
//  Created by Dylan Hanson on 4/15/18.
//

import Foundation

public struct TimeDuration {
	
	public let startTime: EnscribedTime
	public let endTime: EnscribedTime
	
	public init(startTime: EnscribedTime, endTime: EnscribedTime) {
		self.startTime = startTime
		self.endTime = endTime
	}
	
}


extension TimeDuration: Hashable {
	
	public static func ==(lhs: TimeDuration, rhs: TimeDuration) -> Bool {
		return lhs.startTime == rhs.startTime && lhs.endTime == rhs.endTime
	}
	
	public var hashValue: Int {
		return startTime.hashValue ^ endTime.hashValue
	}
	
	public func duration() -> (hours: Int, minutes: Int) {
		return (hours: abs(self.endTime.hour - self.startTime.hour), minutes: abs(self.endTime.minute - self.startTime.minute))
	}
	
}
