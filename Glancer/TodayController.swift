//
//  TodayController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/25/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class TodayController: DayController {
	
	private var state: TodayManager.TodayScheduleState!
	
	override func viewDidLoad() {
		self.date = Date.today
		
		super.viewDidLoad()
	}
	
	override func setupNavigationItem() {
		// Doesn't need to be done.
	}
	
	override func registerScheduleListener() {
		TodayManager.instance.statusWatcher.onSuccess(self) {
			state in
			
			self.handleStateChange(state: state)
		}
	}
	
	override func loadPreexistingSchedule() {
		self.handleStateChange(state: TodayManager.instance.currentState)
	}
	
	private func handleStateChange(state: TodayManager.TodayScheduleState) {
		self.state = state
		self.tableHandler.reload()
	}
	
	private func updateNavigationItem(today: Bool) {
		self.navigationItem.title = today ? "Today" : "Tomorrow"
		if let item = self.navigationItem as? SubtitleNavigationItem {
			item.subtitle = (today ? Date.today : Date.today.dayInRelation(offset: 1)).prettyDate
		}
	}
	
	override func buildCells(layout: TableLayout) {
		guard let events = self.events, let lunch = self.lunch else {
			print("No supplemental data")
			return
		}
		
		switch self.state! {
		case .LOADING:
			print("Loading")
		case .ERROR:
			print("Error")
		case .NULL:
			print("NULL")
		case .NO_CLASS(let schedule):
			print("No Class!")
		case let .BEFORE_SCHOOL(schedule, firstBlock, minutesUntil):
			print("Before school")
		case let .BETWEEN_CLASS(schedule, nextBlock, minutesUntil):
			print("Between classes")
		case let .IN_CLASS(schedule, current, next, minutesLeft):
			print("In class!")
		case let .AFTER_SCHOOL(today, tomorrow):
			print("After school")
			
			let composites = self.generateCompositeList(schedule: today, blocks: today.getBlocks(), lunch: lunch, events: events)
			self.tableHandler.addModule(BlockListModule(composites: composites))
		}		
	}
	
}
