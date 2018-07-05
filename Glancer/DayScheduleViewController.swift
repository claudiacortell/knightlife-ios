//
//  DayScheduleViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/21/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class DayScheduleViewController: TableHandler {
	
	var parentController: DayViewController!
	
	@IBOutlet weak private var tableReference: UITableView!
	@IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak private var failedLabel: UILabel!
	@IBOutlet weak private var noSchoolLabel: UILabel!
	
	private var loading = false // Lock
	private var schedule: DateSchedule?
	private var lunchMenu: LunchMenu?
	
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
	
	override func refresh() {
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
			var showFooter = false
			
			let status = TodayManager.instance.getCurrentScheduleInfo(self.schedule!)
			if status.scheduleState == .BEFORE_SCHOOL {
				block = status.nextBlock!
				header = "Before School"
				subtitle = TimeUtils.timeToString(years: 0, days: 0, hours: status.minutesRemaining.hours, min: status.minutesRemaining.minutes, sec: 0)
			} else if status.scheduleState == .BETWEEN_CLASS {
				block = status.nextBlock!
				header = "Next Class"
				subtitle = "in \(TimeUtils.timeToString(years: 0, days: 0, hours: status.minutesRemaining.hours, min: status.minutesRemaining.minutes, sec: 0))"
				showFooter = true
			} else if status.scheduleState == .IN_CLASS {
				block = status.curBlock!
				header = "In Class"
				subtitle = "for \(TimeUtils.timeToString(years: 0, days: 0, hours: status.minutesRemaining.hours, min: status.minutesRemaining.minutes, sec: 0))"
				showFooter = true
			}
			
			if block != nil {
				blockSection.addCell(HeaderCell(header: header, subtitle: subtitle, more: nil))
				blockSection.addDividerCell(left: 15, right: 15, backgroundColor: UIColor.white, insetColor: UIColor(hex: "F5F5F8")!)
				
				self.addBlockCell(block!, schedule: schedule, section: blockSection)
				
				if showFooter {
					blockSection.addDividerCell(left: 15, right: 15, backgroundColor: UIColor.white, insetColor: UIColor(hex: "F5F5F8")!)
					blockSection.addCell("footer").setHeight(30).setSelectionStyle(.none)
				}
				
				blockSection.addSpacerCell().setBackgroundColor(UIColor(hex: "F5F5F8")!).setHeight(7)
			}
			
			blockSection.addCell(HeaderCell(header: "Upcoming", subtitle: nil, more: nil))
			blockSection.addDividerCell(left: 15, right: 15, backgroundColor: .white, insetColor: UIColor(hex: "F5F5F8")!)
			
			if block != nil {
				blocks.append(contentsOf: schedule.getBlocksAfter(block!))
			}
		} else {
			blockSection.addCell(HeaderCell(header: "Blocks", subtitle: nil, more: nil))
			blockSection.addDividerCell(left: 15, right: 15, backgroundColor: .white, insetColor: UIColor(hex: "F5F5F8")!)
			blocks.append(contentsOf: schedule.getBlocks())
		}
		
		for block in blocks {
			self.addBlockCell(block, schedule: schedule, section: blockSection)
			blockSection.addDividerCell(left: 75, right: 15, backgroundColor: .white, insetColor: UIColor(hex: "F5F5F8")!)
		}
	}
	
	private func addBlockCell(_ block: ScheduleBlock, schedule: DateSchedule, section: TableSection) {
		section.addCell("block").setHeight(75).setCallback() {
			template, cell in
			
			if let blockCell = cell as? BlockTableViewCell {
				let analyst = BlockAnalyst(block, schedule: schedule)
				
				blockCell.timeRange = block.time
				blockCell.title = analyst.getDisplayName()
				blockCell.letter = analyst.getDisplayLetter()
				blockCell.color = analyst.getColor()
				
				if block.blockId == .lunch {
					if self.lunchMenu != nil {
						blockCell.moreLabel = "Menu"
					}
				}
			}
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
		
		ProcessChain().link() {
			chain in
			
			ScheduleManager.instance.patchHandler.getSchedule(self.parentController.date, hard: force) {
				error, schedule in
				
				self.schedule = schedule
				chain.next()
			}
		}.link() {
			chain in
			
			LunchManager.instance.menuHandler.getMenu(self.parentController.date, hard: force) {
				error, menu in
				
				self.lunchMenu = menu
				chain.next()
			}
		}.success() {
			chain in
			
			if haptic {
				HapticUtils.IMPACT.impactOccurred()
			}
			
			self.loading = false
			//				self.tableView.refreshControl!.endRefreshing()
			
			if visual {
				self.loadingIndicator.stopAnimating()
				self.reloadTable()
			}
		}.start()
	}
	
}
