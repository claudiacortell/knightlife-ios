//
//  EnscribedDate.swift
//  Pods
//
//  Created by Dylan Hanson on 4/13/18.
//  Copyright © 2018 Charcoal Development. All rights reserved.
//

import Foundation

public struct EnscribedDate {
	
	public let year: Int
	public let month: Int
	public let day: Int
	
	public init?(_ date: Date) {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
		if let year = components.year, let month = components.month, let day = components.day {
			self.init(year: year, month: month, day: day)
		} else {
			return nil
		}
	}
	
	public init?(year: Int, month: Int, day: Int) {
		self.year = year
		self.month = month
		self.day = day
		
		if !TimeUtils.validEnscribedDate(self) {
			return nil
		}
	}
	
	public init?(raw: String = "") {
		let result = TimeUtils.unwrapRawDate(raw: raw)
		self.init(year: result.year, month: result.month, day: result.day)
	}
	
}

extension EnscribedDate: Hashable {
	
	static public func ==(lhs: EnscribedDate, rhs: EnscribedDate) -> Bool {
		return
			lhs.year == rhs.year &&
				lhs.month == rhs.month &&
				lhs.day == rhs.day
	}
	
	public var hashValue: Int {
		return self.day ^ self.month ^ self.year
	}
	
	public var date: Date {
		return TimeUtils.dateFromEnscribedDate(self)
	}
	
	public var dayOfWeek: Day {
		return TimeUtils.getDayOfWeek(self)
	}
	
	public var string: String {
		let month = self.month < 10 ? "0\(self.month)" : String(self.month)
		let day = self.day < 10 ? "0\(self.day)" : String(self.day)
		
		return "\(self.year)-\(month)-\(day)"
	}
	
	public var prettyString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM"
		return "\(dayOfWeek.displayName), \(formatter.string(from: self.date)) \(self.day)"
	}
	
}
