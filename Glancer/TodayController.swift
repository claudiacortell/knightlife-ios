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
	
	private var showStatusBar = false
	override var prefersStatusBarHidden: Bool {
		return !self.showStatusBar
	}
	
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return .slide
	}
	
	override func viewDidLoad() {
		self.date = Date.today
		
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		TodayManager.instance.startTimer()
		self.handleStateChange(state: TodayManager.instance.currentState)
		
//		Animate status bar!
		let animateStatus: Bool = Globals.getData("animate-status") ?? false
		self.showStatusBar = true
		if animateStatus {
			Globals.setData("animate-status", data: false)
			
			UIView.animate(withDuration: 0.5) {
				self.setNeedsStatusBarAppearanceUpdate()
			}
		} else {
			self.setNeedsStatusBarAppearanceUpdate()
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.tableHandler.reload() // Deal with any pesky layout constraint bugs.
	}
	
	override func setupNavigationItem() {
		self.setupMailButtonItem()
		
		self.navigationItem.title = "Today"
		
		if let subtitleItem = self.navigationItem as? SubtitleNavigationItem {
			if let bundle = self.bundle {
				if bundle.schedule.changed {
					subtitleItem.subtitle = "Special"
					subtitleItem.subtitleColor = .red
					
					return
				}
			}
			
			subtitleItem.subtitle = Date.today.prettyDate
			subtitleItem.subtitleColor = UIColor.darkGray
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
			self.bundle = nil
			
			self.showLoading(layout: layout)
			self.setupNavigationItem()
			
			break
		case .ERROR:
			self.bundle = nil
			
			self.showError(layout: layout)
			self.setupNavigationItem()
			
			break
		case let .NO_CLASS(today, nextDay):
			self.bundle = today
			
			self.date = today.date
			self.setupNavigationItem()
			self.showNotices()
			
			self.showNoClass(layout: layout, tomorrow: nextDay)
			break
		case let .BEFORE_SCHOOL(bundle, firstBlock, minutesUntil):
			self.bundle = bundle
			
			self.date = bundle.date
			self.setupNavigationItem()
			self.showNotices()
			
			self.showBeforeSchool(layout: layout, bundle: bundle, block: firstBlock, minutes: minutesUntil)
			break
		case let .BEFORE_SCHOOL_GET_TO_CLASS(bundle, nextBlock, minutesUntil):
			self.bundle = bundle
			
			self.date = bundle.date
			self.setupNavigationItem()
			self.showNotices()
			
			self.showBetweenClass(layout: layout, bundle: bundle, block: nextBlock, minutes: minutesUntil)
			break
		case let .BETWEEN_CLASS(bundle, nextBlock, minutesUntil):
			self.bundle = bundle
			
			self.date = bundle.date
			self.setupNavigationItem()
			self.showNotices()
			
			self.showBetweenClass(layout: layout, bundle: bundle, block: nextBlock, minutes: minutesUntil)
			break
		case let .IN_CLASS(bundle, current, next, minutesLeft):
			self.bundle = bundle
			
			self.date = bundle.date
			self.setupNavigationItem()
			self.showNotices()
			
			self.showInClass(layout: layout, bundle: bundle, current: current, next: next, minutes: minutesLeft)
			break
		case let .AFTER_SCHOOL(bundle, nextDay):
			self.bundle = bundle
			
			self.date = bundle.date
			self.setupNavigationItem()
			self.showNotices()
			
			self.showAfterSchool(layout: layout, bundle: nextDay)
			break
		}		
	}
	
	private func showNoClass(layout: TableLayout, tomorrow: DayBundle?) {
		let events = self.bundle!.events.getOutOfSchoolEvents()
		let addEvents = !events.isEmpty
		
		if tomorrow == nil {
			self.showNone(layout: layout, height: addEvents ? nil : CGFloat(120))
			
			if addEvents {
				layout.addSection().addDivider()
				self.showAfterSchoolEvents(layout: layout, events: events)
			}
			return
		}
		
		self.showNone(layout: layout, height: CGFloat(120))
		
		if addEvents {
			layout.addSection().addDivider()
			self.showAfterSchoolEvents(layout: layout, events: events)
		} else {
			layout.addSection().addDivider()
		}
		
		self.addNextSchoolday(layout: layout, bundle: tomorrow!)
		layout.addSection().addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	private func showBeforeSchool(layout: TableLayout, bundle: DayBundle, block: Block, minutes: Int) {
		layout.addSection().addCell(TodayStatusCell(state: "Before School", minutes: minutes, image: UIImage(named: "icon_clock")!, color: UIColor.black.withAlphaComponent(0.3)))

		let upcomingBlocks = bundle.schedule.getBlocks()
		layout.addSection().addDivider()
		self.tableHandler.addModule(BlockListModule(controller: self, composites: self.generateCompositeList(bundle: bundle, blocks: upcomingBlocks), section: layout.addSection()))
		
		let events = bundle.events.getOutOfSchoolEvents()
		if !events.isEmpty {
			self.showAfterSchoolEvents(layout: layout, events: events)
		}
		
		layout.addSection().addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	private func showBetweenClass(layout: TableLayout, bundle: DayBundle, block: Block, minutes: Int) {
		let analyst = BlockAnalyst(schedule: bundle.schedule, block: block)
		
		let state = analyst.getCourse() == nil ? "\(analyst.getDisplayName()) starting soon" : "Get to \(analyst.getDisplayName())"
		
		let section = layout.addSection()
		section.addCell(TodayStatusCell(state: state, minutes: minutes, image: UIImage(named: "icon_class")!, color: analyst.getColor()))
		
		section.addDivider()
		section.addCell(BlockCell(controller: self, composite: self.generateCompositeBlock(bundle: bundle, block: block)))
		section.addDivider()
		
		section.addSpacerCell().setHeight(30)

		let upcomingBlocks = bundle.schedule.getBlocksAfter(block)
		layout.addSection().addDivider()
		self.tableHandler.addModule(BlockListModule(controller: self, composites: self.generateCompositeList(bundle: bundle, blocks: upcomingBlocks), section: layout.addSection()))
		
		let events = bundle.events.getOutOfSchoolEvents()
		if !events.isEmpty {
			self.showAfterSchoolEvents(layout: layout, events: events)
		}
		
		layout.addSection().addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	private func showInClass(layout: TableLayout, bundle: DayBundle, current: Block, next: Block?, minutes: Int) {
		let analyst = BlockAnalyst(schedule: bundle.schedule, block: current)
		
		let section = layout.addSection()
		section.addCell(TodayStatusCell(state: "in \(analyst.getDisplayName())", minutes: minutes, image: UIImage(named: "icon_clock")!, color: analyst.getColor()))
		
		let secondPassed = Calendar.normalizedCalendar.dateComponents([.second], from: current.time.start, to: Date.today).second!
		let secondDuration = Calendar.normalizedCalendar.dateComponents([.second], from: current.time.start, to: current.time.end).second!
		
		let duration = Float(secondPassed) / Float(secondDuration)
		
		section.addCell(TodayBarCell(color: analyst.getColor(), duration: duration))
		section.addCell(BlockCell(controller: self, composite: self.generateCompositeBlock(bundle: bundle, block: current)))
		section.addDivider()
		
		section.addSpacerCell().setHeight(30)
		
		let upcomingBlocks = bundle.schedule.getBlocksAfter(current)
		layout.addSection().addDivider()
		self.tableHandler.addModule(BlockListModule(controller: self, composites: self.generateCompositeList(bundle: bundle, blocks: upcomingBlocks), section: layout.addSection()))
		
		let events = bundle.events.getOutOfSchoolEvents()
		if !events.isEmpty {
			if upcomingBlocks.isEmpty {
				layout.addSection().addDivider()
			}
			
			self.showAfterSchoolEvents(layout: layout, events: events)
		}
		
		layout.addSection().addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	private func showAfterSchool(layout: TableLayout, bundle: DayBundle?) {
		let events = self.bundle!.events.getOutOfSchoolEvents()
		let showEvents = !events.isEmpty

		guard let bundle = bundle else {
			layout.addSection().addCell(TodayDoneCell()).setHeight(showEvents ? 120 : self.tableView.bounds.size.height)
			
			if !events.isEmpty {
				layout.addSection().addDivider()
				self.showAfterSchoolEvents(layout: layout, events: events)
			}
			return
		}
		
		let doneSection = layout.addSection()
		doneSection.addCell(TodayDoneCell()).setHeight(120)
		
		if showEvents {
			layout.addSection().addDivider()
			self.showAfterSchoolEvents(layout: layout, events: events)
		}
		
		layout.addSection().addDivider()
		self.addNextSchoolday(layout: layout, bundle: bundle)
		
		layout.addSection().addSpacerCell().setBackgroundColor(.clear).setHeight(35)
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
//		section.addDivider()
		section.addCell(TitleCell(title: "Next School Day (\(label))"))
		section.addDivider()

		let compiled = self.generateCompositeList(bundle: bundle, blocks: bundle.schedule.getBlocks())
		self.tableHandler.addModule(BlockListModule(controller: self, composites: compiled, section: section))
		
		let events = bundle.events.getOutOfSchoolEvents()
		if !events.isEmpty {
			self.showAfterSchoolEvents(layout: layout, events: events)
		}
	}
	
}
