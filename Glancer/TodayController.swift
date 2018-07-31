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
import SnapKit

class TodayController: DayController {
	
	private var state: TodayManager.TodayScheduleState!
	
	override func viewDidLoad() {
		self.date = Date.today
		
		super.viewDidLoad()
	}
	
	override func setupNavigationItem() {
		self.navigationItem.title = "Today"
		if let item = self.navigationItem as? SubtitleNavigationItem {
			item.subtitle = Date.today.prettyDate
		}
	}
	
	override func registerListeners() {
		TodayManager.instance.statusWatcher.onSuccess(self) {
			state in
			
			self.handleStateChange(state: state)
		}
	}
	
	override func unregisterListeners() {
//		Stop it from unregistering
	}
	
	override func reloadData() {
		switch TodayManager.instance.currentState {
		case .LOADING:
			break
		default:
			TodayManager.instance.reloadTodayBundle()
			break
		}
		
		self.handleStateChange(state: TodayManager.instance.currentState)
	}
	
	private func handleStateChange(state: TodayManager.TodayScheduleState) {
		self.state = state
		self.tableHandler.reload()
	}
	
	override func buildCells(layout: TableLayout) {
		switch self.state! {
		case .LOADING:
			self.showLoading(layout: layout)
		case .ERROR:
			self.showError(layout: layout)
		case .NO_CLASS(_):
			self.showNone(layout: layout)
		case let .BEFORE_SCHOOL(bundle, firstBlock, minutesUntil):
			self.showBeforeSchool(layout: layout, bundle: bundle, block: firstBlock, minutes: minutesUntil)
		case let .BETWEEN_CLASS(bundle, nextBlock, minutesUntil):
			self.showBetweenClass(layout: layout, bundle: bundle, block: nextBlock, minutes: minutesUntil)
		case let .IN_CLASS(bundle, current, next, minutesLeft):
			self.showInClass(layout: layout, bundle: bundle, current: current, next: next, minutes: minutesLeft)
		case let .AFTER_SCHOOL(bundle):
			self.showAfterSchool(layout: layout, bundle: bundle)
		}
	}
	
	private func showNoClass(layout: TableLayout, bundle: DayBundle?) {
		if bundle == nil {
			self.showNone(layout: layout)
			return
		}
		
		layout.addSection().addCell(NoClassCell()).setHeight(120)
		self.addNextSchoolday(layout: layout, bundle: bundle!)
	}
	
	private func showBeforeSchool(layout: TableLayout, bundle: DayBundle, block: Block, minutes: Int) {
//		Add top item
		
		print("Before school")
		
		let upcomingBlocks = bundle.schedule.getBlocks()
		self.tableHandler.addModule(BlockListModule(controller: self, composites: self.generateCompositeList(bundle: bundle, blocks: upcomingBlocks)))
	}
	
	private func showBetweenClass(layout: TableLayout, bundle: DayBundle, block: Block, minutes: Int) {
//		Add top item
		
		print("Between class")
		
		let upcomingBlocks = bundle.schedule.getBlocksAfter(block)
		self.tableHandler.addModule(BlockListModule(controller: self, composites: self.generateCompositeList(bundle: bundle, blocks: upcomingBlocks)))
	}
	
	private func showInClass(layout: TableLayout, bundle: DayBundle, current: Block, next: Block?, minutes: Int) {
//		Add top item
		
		print("In class")
		
		let upcomingBlocks = bundle.schedule.getBlocksAfter(current)		
		self.tableHandler.addModule(BlockListModule(controller: self, composites: self.generateCompositeList(bundle: bundle, blocks: upcomingBlocks)))
	}
	
	private func showAfterSchool(layout: TableLayout, bundle: DayBundle) {
		let doneSection = layout.addSection()
		doneSection.addCell(TodayDoneCell()).setHeight(120)
		doneSection.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)

		self.addNextSchoolday(layout: layout, bundle: bundle)
	}
	
	private func addNextSchoolday(layout: TableLayout, bundle: DayBundle) {
		let offset = self.date.dayDifference(date: bundle.date)
		var label: String = ""
		switch offset {
		case 0:
			label = "Today"
		case 1:
			label = "Tomorrow"
		case -1:
			label = "Yesterday"
		default:
			if offset < 0 {
				label = "\(abs(offset)) Days Ago"
			} else if offset < 7 {
				label = bundle.date.weekday.displayName
			} else {
				label = "\(offset) Days Away"
			}
		}
		
		let section = layout.addSection()
		section.setTitle("Next School Day (\(label))")
		section.setHeaderHeight(30)
		section.setHeaderFont(UIFont.systemFont(ofSize: 14, weight: .medium))
		section.setHeaderColor(UIColor(hex: "F8F8FA"))
		section.setHeaderIndent(20)
		section.setHeaderTextColor(UIColor(hex: "9F9FAA"))
		
		let compiled = self.generateCompositeList(bundle: bundle, blocks: bundle.schedule.getBlocks())
		self.tableHandler.addModule(BlockListModule(controller: self, composites: compiled, section: section))
	}
	
}
