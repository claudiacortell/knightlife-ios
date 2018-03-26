//
//  CalendarViewManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/25/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class CalendarViewManager: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance
{
	@IBOutlet weak var calendarView: FSCalendar!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.calendarView.dataSource = self
		self.calendarView.delegate = self
		
		self.calendarView.firstWeekday = 2
		
		self.calendarView.bottomBorder.isHidden = true
		
		self.calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20.0, weight: .bold)
		self.calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
		self.calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
	}
	
	private func newController() -> BlockViewController?
	{
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DayViewController"), let blockView = controller as? BlockViewController
		{
			return blockView
		}
		return nil
	}
	
	@IBAction func openYesterday(_ sender: Any)
	{
		if let yesterday = TimeUtils.getDayInRelation(TimeUtils.todayEnscribed, offset: -1)
		{
			if let controller = self.newController()
			{
				controller.date = yesterday
				self.navigationController?.pushViewController(controller, animated: true)
			}
		}
	}
	
	@IBAction func openToday(_ sender: Any)
	{
		if let controller = self.newController()
		{
			controller.date = TimeUtils.todayEnscribed
			self.navigationController?.pushViewController(controller, animated: true)
		}
	}
	
	@IBAction func openTomorrow(_ sender: Any)
	{
		if let tomorrow = TimeUtils.getDayInRelation(TimeUtils.todayEnscribed, offset: 1)
		{
			if let controller = self.newController()
			{
				controller.date = tomorrow
				self.navigationController?.pushViewController(controller, animated: true)
			}
		}
	}
	
	@IBAction func openWeekday(_ sender: UIButton)
	{
		let tag = sender.tag

		print("tag: \(tag)")
		print("dayof week: \(TimeUtils.dayOfWeek())")
		
		if let newDay = TimeUtils.getDayInRelation(Date(), offset: -TimeUtils.dayOfWeek() + tag) // We get the desired day of week from the tag (2 for wednesday) then subtract the current offset to get the actual amount to offset
		{
			if let enscribed = EnscribedDate(newDay)
			{
				if let controller = self.newController()
				{
					controller.date = enscribed
					self.navigationController?.pushViewController(controller, animated: true)
				}
			}
		}
	}
	
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
	{
		if let enscribed = EnscribedDate(date)
		{
			if let controller = newController()
			{
				controller.date = enscribed

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
					self.navigationController?.pushViewController(controller, animated: true)
					self.calendarView.deselect(date)
				})
				
				return
			}
		}
	}
}
