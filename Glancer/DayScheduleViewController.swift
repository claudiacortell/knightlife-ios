//
//  DayScheduleViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/21/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

class DayScheduleViewController: TableHandler {
	
	var parentController: DayViewController!
	
	@IBOutlet weak private var tableReference: UITableView!
	@IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak private var failedLabel: UILabel!
	@IBOutlet weak private var noSchoolLabel: UILabel!
	
	private var loading = false // Lock
	private var schedule: DateSchedule?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.link(self.tableReference)		
		self.parentController.toolbarView.addHeightChangedCallback() {
			height in
			
			self.tableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
//			self.tableView.contentOffset = CGPoint(x: 0, y: height)
		}
		
		self.setupRefreshControl()
		
		self.reloadTable()
		self.reloadSchedule(force: false, visual: true, haptic: false)
	}
	
	private func setupRefreshControl() {
		self.tableView.refreshControl = UIRefreshControl()
		self.tableView.refreshControl!.addTarget(self, action: #selector(DayScheduleViewController.reloadScheduleFromPull), for: UIControlEvents.valueChanged)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if self.schedule == nil || self.schedule!.getBlocks().isEmpty {
			return
		}
		
		self.parentController.toolbarView.didScroll(scrollView.contentOffset.y + self.parentController.toolbarView.originalHeight)
	}
	
	override func loadCells() {
		self.noSchoolLabel.isHidden = true
		self.failedLabel.isHidden = true
		
		if self.loading {
			return
		}

		if self.schedule == nil {
			self.failedLabel.isHidden = false
			return
		}
		
		let schedule = self.schedule!
		
		if schedule.getBlocks().isEmpty {
			self.noSchoolLabel.isHidden = false
			return
		}
		
		var blocks: [ScheduleBlock] = []
		let blockSection = self.tableForm.addSection()
		if parentController.date == TimeUtils.todayEnscribed && parentController.isTodayView {
			var block: ScheduleBlock?
			var header = ""
			var subtitle = ""
			
			let status = TodayManager.instance.getCurrentScheduleInfo(self.schedule!)
			if status.scheduleState == .BEFORE_SCHOOL {
				block = status.nextBlock!
				header = "Before School"
				subtitle = TimeUtils.timeToString(hours: status.minutesRemaining.hours, min: status.minutesRemaining.minutes)
			} else if status.scheduleState == .BETWEEN_CLASS {
				block = status.nextBlock!
				header = "Next Class"
				subtitle = "in \(TimeUtils.timeToString(hours: status.minutesRemaining.hours, min: status.minutesRemaining.minutes))"
			} else if status.scheduleState == .IN_CLASS {
				block = status.curBlock!
				header = "In Class"
				subtitle = "for \(TimeUtils.timeToString(hours: status.minutesRemaining.hours, min: status.minutesRemaining.minutes))"
			}
			
			if block != nil {
				blockSection.addCell(HeaderCell(header: header, subtitle: subtitle, more: nil))
				blockSection.addDividerCell(left: 15, right: 15, backgroundColor: UIColor.white, insetColor: UIColor("F5F5F8"))
				
				blockSection.addCell("block").setHeight(75).setCallback() {
					template, cell in
					
					if let blockCell = cell as? BlockTableViewCell {
						let analyst = BlockAnalyst(block!, schedule: schedule)
						
						blockCell.timeRange = block!.time
						blockCell.title = analyst.getDisplayName()
						blockCell.letter = analyst.getDisplayLetter()
						blockCell.color = analyst.getColor()
					}
				}
				
				blockSection.addDividerCell(left: 15, right: 15, backgroundColor: UIColor.white, insetColor: UIColor("F5F5F8"))
				blockSection.addCell("footer").setHeight(30).setSelection(.none)
				blockSection.addSpacerCell().setBackgroundColor(UIColor("F5F5F8")).setHeight(7)
			}
			
			blockSection.addCell(HeaderCell(header: "Upcoming", subtitle: nil, more: nil))
			blockSection.addDividerCell(left: 15, right: 15, backgroundColor: .white, insetColor: UIColor("F5F5F8"))
			
			if block != nil {
				blocks.append(contentsOf: schedule.getBlocksAfter(block!))
			}
		} else {
			blockSection.addCell(HeaderCell(header: "Blocks", subtitle: nil, more: nil))
			blockSection.addDividerCell(left: 15, right: 15, backgroundColor: .white, insetColor: UIColor("F5F5F8"))
			blocks.append(contentsOf: schedule.getBlocks())
		}
		
		for block in blocks {
			blockSection.addCell("block").setHeight(75).setCallback() {
				template, cell in
				
				if let blockCell = cell as? BlockTableViewCell {
					let analyst = BlockAnalyst(block, schedule: schedule)
					
					blockCell.timeRange = block.time
					blockCell.title = analyst.getDisplayName()
					blockCell.letter = analyst.getDisplayLetter()
					blockCell.color = analyst.getColor()
				}
			}
			
			blockSection.addDividerCell(left: 75, right: 15, backgroundColor: .white, insetColor: UIColor("F5F5F8"))
		}
	}
	
	@objc private func reloadScheduleFromPull() {
		self.reloadSchedule(force: true, visual: true, haptic: true)
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
		
		ScheduleManager.instance.patchHandler.getSchedule(self.parentController.date, hard: force) {
			error, schedule in
			
			if haptic {
				HapticUtils.IMPACT.impactOccurred()
			}
			
			self.loading = false
			self.schedule = schedule
			
			self.tableView.refreshControl!.endRefreshing()
			
			if visual {
				self.loadingIndicator.stopAnimating()
				self.reloadTable()
			}
		}
	}
	
}
