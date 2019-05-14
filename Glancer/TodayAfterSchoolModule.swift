//
//  TodayAfterSchoolModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class TodayAfterSchoolModule: TableModule {
	
	let controller: DayController
	let table: UITableView
	let today: DayBundle
	let tomorrow: DayBundle?
	
	init(controller: DayController, table: UITableView, today: DayBundle, tomorrow: DayBundle?) {
		self.controller = controller
		self.table = table
		self.today = today
		self.tomorrow = tomorrow
		
		super.init()
	}
	
	override func build() {
//		Today
		if self.tomorrow == nil {
			self.addSection().addCell(TodayDoneCell()).setHeight(!self.today.events.timeEvents.isEmpty ? 120 : self.table.frame.height)
			
			if !self.today.events.timeEvents.isEmpty {
				self.addModule(AfterSchoolEventsModule(bundle: self.today, title: "After School", options: [ .topBorder, .bottomBorder ]))
			}
			
			return
		}
		
//		Tomorrow
		self.addSection().addCell(TodayDoneCell()).setHeight(120)
		
		if !self.today.events.timeEvents.isEmpty {
			self.addModule(AfterSchoolEventsModule(bundle: self.today, title: "After School", options: [ .topBorder ]))
		}
		
		self.addModule(TodayNextDayModule(controller: self.controller, tomorrow: self.tomorrow!))
		
		self.addSection().addSpacerCell().setHeight(35)
	}
	
}
