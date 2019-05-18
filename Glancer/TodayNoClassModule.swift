//
//  TodayNoClassModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

class TodayNoClassModule: TableModule {
	
	let controller: DayController
	let table: UITableView
	let today: Day
	let tomorrow: Day?
	
	init(controller: DayController, table: UITableView, today: Day, tomorrow: Day?) {
		self.controller = controller
		self.table = table
		self.today = today
		self.tomorrow = tomorrow
		
		super.init()
	}
	
	override func build() {
		if self.tomorrow == nil {
			self.addModule(TodayNoClassNoTomorrowModule(table: self.table, today: self.today))
		} else {
			self.addModule(TodayNoClassWithTomorrowModule(controller: self.controller, table: self.table, today: self.today, tomorrow: self.tomorrow!))
		}
		
		self.addSection().addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
}

fileprivate class TodayNoClassNoTomorrowModule: TableModule {
	
	let table: UITableView
	let today: Day
	
	init(table: UITableView, today: Day) {
		self.table = table
		self.today = today
		
		super.init()
	}
	
	override func build() {
		if !today.events.timeEvents.isEmpty {
			self.addModule(NoClassModule(table: self.table, fullHeight: false))
			self.addModule(AfterSchoolEventsModule(bundle: self.today, title: "Events", options: [.topBorder, .bottomBorder]))
		} else {
			self.addModule(NoClassModule(table: self.table, fullHeight: true))
		}
	}
	
}

fileprivate class TodayNoClassWithTomorrowModule: TableModule {
	
	let controller: DayController
	let table: UITableView
	let today: Day
	let tomorrow: Day
	
	init(controller: DayController, table: UITableView, today: Day, tomorrow: Day) {
		self.controller = controller
		self.table = table
		self.today = today
		self.tomorrow = tomorrow
		
		super.init()
	}
	
	override func build() {
		self.addModule(NoClassModule(table: self.table, fullHeight: false))
		
		if !today.events.timeEvents.isEmpty {
			self.addModule(AfterSchoolEventsModule(bundle: self.today, title: "Events", options: [.topBorder]))
		}
		
		self.addModule(TodayNextDayModule(controller: self.controller, tomorrow: self.tomorrow))
	}
	
}
