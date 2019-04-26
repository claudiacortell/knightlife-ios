//
//  DayBundle.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/28/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

struct DayBundle {
	
	fileprivate let uuid = UUID()
	
	let date: Date
	
	let schedule: Schedule
	let events: EventList
	let menu: Lunch
	
}

extension DayBundle: Equatable {
	
	static func == (lhs: DayBundle, rhs: DayBundle) -> Bool {
		return lhs.uuid == rhs.uuid
	}
	
}
