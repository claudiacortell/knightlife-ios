//
//  CalendarController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/26/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import SnapKit

class CalendarController: UIViewController, TableBuilder, ErrorReloadable, PushRefreshListener {

	var refreshListenerType: [PushRefreshType] = [.EVENTS, .SCHEDULE]
	
	@IBOutlet weak var tableView: UITableView!
	var tableHandler: TableHandler!
	
	@IBOutlet weak var calendarView: CalendarView!
	
	var upcomingItems: [(date: Date, items: [UpcomingItem])]?
	var upcomingItemsError: Error?
	var upcomingItemsLoaded: Bool {
		return self.upcomingItems != nil || self.upcomingItemsError != nil
	}
	
	func openDay(date: Date) {
		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Day") as? DayController else {
			return
		}
		
		controller.date = date
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.builder = self
				
		self.calendarView.controller = self
		self.calendarView.setupViews()
		
		self.fetchUpcoming {
			self.tableHandler.reload()
		}
		
		self.registerListeners()
	}
//
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(animated)
//
//		self.calendarView.setupViews()
//		self.setupNavigation()
//
//		self.tableHandler.reload()
//	}
//
	private func registerListeners() {
		TodayManager.instance.nextDayWatcher.onSuccess(self) {
			date in
			
			self.calendarView.setupViews()
			self.setupNavigation()
			
			self.tableHandler.reload()
		}
	}
	
	private func setupNavigation() {
		if let navigation = self.navigationItem as? SubtitleNavigationItem {
			let formatter = Date.normalizedFormatter
			formatter.dateFormat = "MMMM"
			navigation.subtitle = "\(formatter.string(from: Date.today))"
		}
	}
	
	private func setupRefresh() {
		if self.tableView.refreshControl != nil {
			return
		}
		
		let refreshControl = UIRefreshControl()
		self.tableView.refreshControl = refreshControl
		
		refreshControl.backgroundColor = .clear
		refreshControl.tintColor = Scheme.dividerColor.color
		
		refreshControl.addTarget(self, action: #selector(self.refreshSubmitted(_:)), for: .valueChanged)
	}
	
	private func removeRefresh() {
		if self.tableView.refreshControl != nil {
			self.tableView.refreshControl?.endRefreshing()
			self.tableView.refreshControl?.removeFromSuperview()
			self.tableView.refreshControl = nil
		}
	}
	
	@objc func refreshSubmitted(_ sender: Any) {
		self.fetchUpcoming {
			self.tableView.refreshControl?.endRefreshing()
			self.tableHandler.reload()
		}
	}
	
	func doListenerRefresh(date: Date) {
		self.fetchUpcoming {
			self.tableHandler.reload()
		}

		self.tableHandler.reload()
	}
	
	func fetchUpcoming(then: @escaping () -> Void = {}) {
		self.upcomingItems = nil
		self.upcomingItemsError = nil
		
		UpcomingWebCall(date: Date.today).callback() {
			result in
			
			switch result {
			case .success(let items):
				self.upcomingItems = items
			case .failure(let error):
				self.upcomingItemsError = error
				print(error.localizedDescription)
			}
			
			Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {
				timer in
				then()
			}
		}.execute()
	}
	
	func buildCells(layout: TableLayout) {
		if !self.upcomingItemsLoaded {
			self.removeRefresh()
			layout.addSection().addCell(LoadingCell()).setHeight(self.tableView.bounds.size.height)
			return
		}
		
		if let _ = self.upcomingItemsError {
			self.removeRefresh()
			layout.addSection().addCell(ErrorCell(reloadable: self)).setHeight(self.tableView.bounds.size.height)
			return
		}
		
		self.setupRefresh()
		let list = self.upcomingItems!

		if list.isEmpty {
//			No items
			return
		}
		
		for item in list {
			// Check if there are any events here that can't be displayed because of grade settings
			var invalidEvents = 0
			for upcoming in item.items {
				if upcoming.type == .event {
					if !(upcoming as? EventUpcomingItem)!.event.isRelevantToUser() {
						invalidEvents += 1
					}
				}
			}
			
			if invalidEvents >= item.items.count {
//				If every item in here is an event, and none of them can be shown, just continue
				continue
			}
			
			let section = layout.addSection()
			
			section.addDivider()			
			section.addCell(TitleCell(title: item.date.prettyDate))
			section.addDivider()
			
			var views: [AttachmentView] = []
			for upcoming in item.items {
				if let eventUpcoming = upcoming as? EventUpcomingItem {
					if !eventUpcoming.event.isRelevantToUser() {
						continue
					}
				}
				
				views.append(upcoming.generateAttachmentView())
			}
			
			let cell = UpcomingAttachmentCell(attachmentViews: views)
			cell.clickHandler = {
				self.openDay(date: item.date)
			}
			section.addCell(cell)
		}
		
		let newSection = layout.addSection()
		newSection.addDivider()
		newSection.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	func reloadData() {
		self.fetchUpcoming {
			self.tableHandler.reload()
		}
	}
	
}
