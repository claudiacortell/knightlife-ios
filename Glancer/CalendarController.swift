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

class CalendarController: UIViewController, TableHandlerDataSource, ErrorReloadable, PushRefreshListener {

	var refreshListenerType: [PushRefreshType] = [.EVENTS, .SCHEDULE]
	
	@IBOutlet weak var tableView: UITableView!
	var tableHandler: TableHandler!
	
	@IBOutlet weak var calendarView: CalendarView!
	
	
	func openDay(date: Date) {
		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Day") as? DayController else {
			return
		}
		
		controller.date = date
        tableView.dataSource = controller as? UITableViewDataSource
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.dataSource = self
				
		self.calendarView.controller = self
		
		self.registerListeners()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.calendarView.setupViews()
		self.setupNavigation()

		self.tableHandler.reload()
	}

	private func registerListeners() {
		PushNotificationManager.instance.addListener(type: .REFRESH, listener: self)
		
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
		
	}
	
	func doListenerRefresh(date: Date, queue: DispatchGroup) {
		queue.enter()
		

		self.tableHandler.reload()
	}
	
	
	func buildCells(handler: TableHandler, layout: TableLayout) {
		
		self.setupRefresh()
		
		let newSection = layout.addSection()
		newSection.addDivider()
		newSection.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	func reloadData() {
		self.tableHandler.reload()
	}
	
}
