//
//  TodayNextDayModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class TodayNextDayModule: TableModule {
	
	let controller: DayController
	let tomorrow: DayBundle
	
	init(controller: DayController, tomorrow: DayBundle) {
		self.controller = controller
		self.tomorrow = tomorrow
		
		super.init()
	}
	
	override func build() {
		let today = Date.today
		
		let offset = today.dayDifference(date: self.tomorrow.date)
		var label: String = ""
		switch offset {
		case 0:
			label = "Today"
		case 1:
			label = "Tomorrow"
		case -1:
			label = "Yesterday"
		default:
			if offset < 0 {
				label = "\(abs(offset)) Days Ago"
			} else if offset < 7 {
				label = self.tomorrow.date.weekday.displayName
			} else {
				label = "\(offset) Days Away"
			}
		}
		
		self.addModule(BlockListModule(controller: self.controller, bundle: self.tomorrow, title: "Next School Day (\(label))", blocks: self.tomorrow.schedule.getBlocks(), options: [.topBorder, .bottomBorder]))
		self.addModule(AfterSchoolEventsModule(bundle: self.tomorrow, title: "After School (\(label))", options: [ .bottomBorder ]))
	}
}
