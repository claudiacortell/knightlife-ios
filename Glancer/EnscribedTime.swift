//
//  EnscribedTime.swift
//  Pods
//
//  Created by Dylan Hanson on 4/13/18.
//  Copyright © 2018 Charcoal Development. All rights reserved.
//

import Foundation

public struct EnscribedTime {
	
	public let hour: Int
	public let minute: Int
	
	public var valid: Bool {
		get {
			return self.hour != -1 && self.minute != -1
		}
	}
	
	public init(hour: Int, minute: Int) {
		self.hour = hour
		self.minute = minute
	}
	
	public init(raw: String = "") {
		let result = TimeUtils.unwrapRawTime(raw: raw)
		
		self.hour = result.hour
		self.minute = result.minute
	}
	
}

extension EnscribedTime: Hashable {
	
	static public func ==(lhs: EnscribedTime, rhs: EnscribedTime) -> Bool {
		return
			lhs.hour == rhs.hour
				&& lhs.minute == rhs.minute
	}
	
	public var hashValue: Int {
		return self.hour ^ self.minute
	}
	
	public func toDate(enscribedDate: EnscribedDate = TimeUtils.todayEnscribed) -> Date? {
		return TimeUtils.dateFromEnscribed(enscribedDate: enscribedDate, enscribedTime: self)
	}
	
	public func toString() -> String {
		let hour = self.hour > 12 ? self.hour % 12 : self.hour
		var minute = String(self.minute)
		if minute.count == 1 { minute = "0\(minute)" }
		
		return "\(hour):\(minute)"
	}
	
}
