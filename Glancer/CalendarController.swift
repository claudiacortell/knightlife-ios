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
import FSCalendar
import SnapKit

class CalendarController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
	
	var today: Date = Date.today {
		didSet {
			self.calendarView.select(self.today, scrollToDate: false)
			self.calendarView.reloadData()
		}
	}
	
	@IBOutlet weak var tableView: UITableView!
	var tableHandler: TableHandler!
	
	@IBOutlet weak var calendarView: FSCalendar!
	@IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.setupCalendar()
	}
	
	private func setupCalendar() {
		self.calendarView.scrollDirection = .horizontal
		
		self.calendarView.delegate = self
		self.calendarView.dataSource = self
		
		let shadowView = UIView()
		shadowView.backgroundColor = Scheme.dividerColor.color
		self.calendarView.addSubview(shadowView)
		shadowView.snp.makeConstraints() {
			constrain in
			constrain.leading.equalToSuperview()
			constrain.trailing.equalToSuperview()
			constrain.bottom.equalToSuperview()
			constrain.height.equalTo(1)
		}
		
		self.calendarView.firstWeekday = 2
		self.calendarView.allowsMultipleSelection = false		
	}
	
	func minimumDate(for calendar: FSCalendar) -> Date {
		return Date.today
	}
	
	func maximumDate(for calendar: FSCalendar) -> Date {
		return Date.today
	}
	
	func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
		
	}
	
	
	
//	func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
//		calendar.deselectDate(date)
//
//		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Day") as? DayController else {
//			return
//		}
//
//		controller.date = date
//		self.navigationController?.pushViewController(controller, animated: true)
//	}
	
}
