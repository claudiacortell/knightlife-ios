//
//  TodayViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 4/27/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

class TodayViewController: TableHandler {
	
	@IBOutlet weak var tableReference: UITableView!

	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var dateLabel: UILabel!
	
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var subtitleConstraint: NSLayoutConstraint!
	
	private var subtitleConstraintDefault: CGFloat!
	
	private var loading = false // Lock
	private var schedule: DateSchedule?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.link(self.tableReference)
		self.tableView.refreshControl = UIRefreshControl()		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.reloadTable()
				
		self.reloadSchedule(force: false, visual: true, haptic: false)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let scroll = scrollView.contentOffset.y
		
//		self.subtitleConstraint.constant = self.subtitleConstraintDefault + -1 * scroll // -1 because the content insets mean that the content offset is (-1)*(header height)
		
//		let percent = max(0.0, min(1.0, self.subtitleConstraint.constant / self.subtitleConstraintDefault))
//		self.subtitleLabel.layer.opacity = Float(percent)
	}
	
	override func loadCells() {
		if self.loading {
			return
		}

		if self.schedule == nil {
//			ERROR DISPLAY
			return
		}
		
		let schedule = self.schedule!
		
		if let subtitle = schedule.subtitle {
			self.subtitleLabel.text = subtitle
			
			self.subtitleConstraintDefault = self.subtitleLabel.frame.height
		} else {
			
		}
		
		self.tableView.contentInset = UIEdgeInsets(top: self.headerView.frame.height, left: 0, bottom: 0, right: 0)
		self.tableView.contentOffset = CGPoint(x: 0.0, y: -self.tableView.contentInset.top)
		
		let currentSection = self.tableForm.addSection()

		currentSection.addCell("current").setHeight(100)

		let cellSection = self.tableForm.addSection()
		cellSection.setHeaderFont(UIFont.systemFont(ofSize: 22, weight: .bold)).setTitle("Upcoming").setHeaderHeight(24).setHeaderColor(UIColor.white).setHeaderTextColor(UIColor.darkGray).setHeaderIndent(15.0)

		
		for _ in 0..<10 {
			cellSection.addCell("block").setHeight(60.0)
		}
		
//		for block in self.schedule!.blocks {
//			cellSection.addCell("block").setCallback() {
//				template, cell in
//
////				CONFIGURE BLOCK
//			}
//		}
		
//		Set SUBTITLE
	}
	
	private func reloadSchedule(force: Bool, visual: Bool, haptic: Bool) {
		if self.loading { return }
		else { self.loading = true }
		
		if haptic {
			HapticUtils.SELECTION.selectionChanged()
		}
		
		if visual {
			self.reloadTable()

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
				self.reloadTable()
			}
		}
	}
	
}
