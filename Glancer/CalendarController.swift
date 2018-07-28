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
import JTCalendar
import SnapKit

class CalendarController: UIViewController, JTCalendarDelegate {
	
	var today: Date = Date.today {
		didSet {
			self.calendarHandler.setDate(self.today)
			self.calendarHandler.reload()
		}
	}
	
	@IBOutlet weak var tableView: UITableView!
	var tableHandler: TableHandler!
	
	@IBOutlet weak var calendarWrapper: UIView!
	
	private var calendarHandler: JTCalendarManager!
	private var calendarMenu: JTCalendarMenuView!
	private var calendarContent: JTHorizontalCalendarView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.setupCalendar()
	}
	
	private func setupCalendar() {
		let calMenu = JTCalendarMenuView()
		let calContent = JTHorizontalCalendarView()
		
		self.calendarWrapper.addSubview(calMenu)
		self.calendarWrapper.addSubview(calContent)
		
		calMenu.snp.makeConstraints() {
			constrain in
			constrain.top.equalToSuperview()
			constrain.leading.equalToSuperview()
			constrain.trailing.equalToSuperview()
			constrain.bottom.equalTo(calContent.snp.top)
		}
		
		calContent.snp.makeConstraints() {
			constrain in
			constrain.leading.equalToSuperview()
			constrain.trailing.equalToSuperview()
			constrain.bottom.equalToSuperview()
		}
		
		let shadowView = UIView()
		shadowView.backgroundColor = UIColor(hex: "E1E1E6")!
		self.calendarWrapper.addSubview(shadowView)
		
		shadowView.snp.makeConstraints() {
			constrain in
			
			constrain.height.equalTo(1)
			constrain.bottom.equalToSuperview()
			constrain.leading.equalToSuperview()
			constrain.trailing.equalToSuperview()
		}
		
		self.calendarHandler = JTCalendarManager(locale: Calendar.locale_us, andTimeZone: Calendar.timezone)
		self.calendarHandler.delegate = self
		
		self.calendarHandler.menuView = calMenu
		self.calendarHandler.contentView = calContent
		self.calendarHandler.setDate(self.today)
		
		self.calendarHandler.settings.pageViewNumberOfWeeks = 4
	}
	
	func calendar(_ calendar: JTCalendarManager!, canDisplayPageWith date: Date!) -> Bool {
		return self.canShowDate(date: date)
	}
	
	func calendarDidLoadNextPage(_ calendar: JTCalendarManager!) {
		
	}
	
	func calendarDidLoadPreviousPage(_ calendar: JTCalendarManager!) {
		
	}
	
	func calendarBuildMenuItemView(_ calendar: JTCalendarManager!) -> UIView! {
		let view = UIView()
		view.backgroundColor = UIColor.green
		return view
	}
	
//	func calendarBuildDayView(_ calendar: JTCalendarManager!) -> (UIView & JTCalendarDay)! {
//
//	}
	
	func calendar(_ calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: Date!) {
		
	}

	func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
		if !self.canShowDate(date: dayView.date()) {
			dayView.isHidden = true
			return
		}
		
		dayView.isHidden = false
	}
	
	func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: (UIView & JTCalendarDay)!) {
		
	}
	
	private func canShowDate(date: Date) -> Bool {
		let helper = JTDateHelper(locale: Calendar.locale_us, andTimeZone: Calendar.timezone)!
		if helper.date(date, isTheSameWeekThan: self.today) {
			return true
		}
		
		let firstDayOfThisWeek = self.today.dayInRelation(offset: -self.today.dayOfWeek)
		let lastDayOfThisWeek = firstDayOfThisWeek.dayInRelation(offset: 6)
		
		let lastViableDay = helper.add(to: lastDayOfThisWeek, weeks: 4)
		return helper.date(date, isEqualOrAfter: firstDayOfThisWeek, andEqualOrBefore: lastViableDay)
	}
	
}
