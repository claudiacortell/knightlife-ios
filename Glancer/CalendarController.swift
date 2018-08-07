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

class CalendarController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	var tableHandler: TableHandler!
	
	@IBOutlet weak var calendarView: CalendarView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.calendarView.controller = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.calendarView.setupViews()
		self.setupNavigation()
	}
	
	private func setupNavigation() {
		if let navigation = self.navigationItem as? SubtitleNavigationItem {
			let formatter = Date.normalizedFormatter
			formatter.dateFormat = "MMMM"
			navigation.subtitle = "\(formatter.string(from: Date.today))"
		}
	}
	
}
