//
//  DayController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/25/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class DayController: UIViewController, TableBuilder {
	
	@IBOutlet weak var tableView: UITableView!
	var tableHandler: TableHandler!
	
	var date: Date!
	
	var schedule: DateSchedule?
	var scheduleError: Error?
	var scheduleDidDownload: Bool { return schedule != nil || scheduleError != nil }
	
	var events: EventList?
	var eventsError: Error?
	var eventsDidDownload: Bool { return self.events != nil || self.eventsError != nil }
	
	var lunch: LunchMenu?
	var lunchError: Error?
	var lunchDidLoad: Bool { return self.lunch != nil || self.lunchError != nil }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupNavigationItem()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.builder = self
		
		self.registerScheduleListener()
		self.registerEventListener()
		self.registerLunchListener()
		
		self.loadPreexistingSchedule()
		self.loadPreexistingLunch()
		self.loadPreexistingEvents()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
	}
	
	func setupNavigationItem() {
		self.navigationItem.title = self.date.prettyDate
	}
	
	func registerScheduleListener() {
		ScheduleManager.instance.getPatchWatcher(date: self.date).onSuccess(self) {
			schedule in
			
			self.schedule = schedule
			self.scheduleError = nil
			
			self.tableHandler.reload()
		}
		
		ScheduleManager.instance.getPatchWatcher(date: self.date).onFailure(self) {
			error in
			
			self.schedule = nil
			self.scheduleError = error
			
			self.tableHandler.reload()
		}
	}
	
	func registerEventListener() {
		EventManager.instance.getEventWatcher(date: self.date).onSuccess(self) {
			events in
			
			self.events = events
			self.eventsError = nil
			
			self.tableHandler.reload()
		}
		
		EventManager.instance.getEventWatcher(date: self.date).onFailure(self) {
			error in
			
			self.events = nil
			self.eventsError = error
			
			self.tableHandler.reload()
		}
	}
	
	func registerLunchListener() {
		LunchManager.instance.getLunchWatcher(date: self.date).onSuccess(self) {
			menu in
			
			self.lunch = menu
			self.lunchError = nil
			
			self.tableHandler.reload()
		}
		
		LunchManager.instance.getLunchWatcher(date: self.date).onFailure(self) {
			error in
			
			self.lunch = nil
			self.lunchError = error
			
			self.tableHandler.reload()
		}
	}
	
	func loadPreexistingSchedule() {
		ScheduleManager.instance.loadSchedule(date: self.date)
	}
	
	func loadPreexistingEvents() {
		EventManager.instance.getEvents(date: self.date)
	}
	
	func loadPreexistingLunch() {
		LunchManager.instance.fetchLunchMenu(date: self.date)
	}
	
	func buildCells(layout: TableLayout) {
		if !self.scheduleDidDownload || !self.lunchDidLoad || !self.eventsDidDownload {
			print("Loading")
			return
		}
		
		guard let schedule = self.schedule, let menu = self.lunch, let events = self.events else {
			print("Error")
			return
		}
		AttachmentView()
		self.tableHandler.addModule(BlockListModule(schedule: schedule, blocks: schedule.getBlocks()))
	}
	
}
