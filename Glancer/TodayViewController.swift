//
//  TodayViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 4/27/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

class TodayViewController: UIViewController, TableBuilder {
//	UNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSEDUNUSED
	@IBOutlet weak var tableReference: UITableView!
	private var tableHandler: TableHandler!
	
	@IBOutlet weak var toolbarReference: ToolbarView!
	
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	private var loading = false // Lock
	private var schedule: DateSchedule?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableReference)
		self.tableHandler.builder = self
		
		self.tableReference.refreshControl = UIRefreshControl()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
		self.reloadSchedule(force: false, visual: true, haptic: false)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.toolbarReference.didScroll(scrollView.contentOffset.y)
	}
	
	func buildCells(layout: TableLayout) {
		if self.loading {
			return
		}

		if self.schedule == nil {
//			ERROR
			return
		}
		
		let schedule = self.schedule!

		self.toolbarReference.subtitle = schedule.subtitle
	}
	
	private func reloadSchedule(force: Bool, visual: Bool, haptic: Bool) {
		if self.loading { return }
		else { self.loading = true }
		
		if haptic {
			HapticUtils.SELECTION.selectionChanged()
		}
		
		if visual {
			self.tableHandler.reload()

			self.loadingIndicator.isHidden = false
			self.loadingIndicator.startAnimating()
		}
		
		ScheduleManager.instance.patchHandler.getSchedule(TimeUtils.todayEnscribed, hard: force) {
			error, schedule in
			
			if haptic {
				HapticUtils.IMPACT.impactOccurred()
			}
			
			self.loading = false
			self.schedule = schedule
			
			if visual {
				self.loadingIndicator.stopAnimating()
				self.tableHandler.reload()
			}
		}
	}
	
}
