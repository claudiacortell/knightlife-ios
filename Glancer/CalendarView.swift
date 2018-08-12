//
//  CalendarView.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/7/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CalendarView: UIView {
	
	var controller: CalendarController!
	
	@IBOutlet weak private var weekAStackView: UIStackView!
	@IBOutlet weak private var weekBStackView: UIStackView!
	@IBOutlet weak private var weekCStackView: UIStackView!
	@IBOutlet weak private var weekDStackView: UIStackView!
	
	lazy var weekStackList: [UIStackView] = {
		return [self.weekAStackView, self.weekBStackView, self.weekCStackView, self.weekDStackView]
	}()
	
	private var startOfWeek: Date!
	
	private var dates: [[Date]] {
		let today = Date.today
		let startOfWeek = today.dayInRelation(offset: -(today.dayOfWeek))
		
		var days: [[Date]] = []
		
		for weekNum in 0..<4 {
			var setupDates: [Date] = []
			for dayNum in 0..<7 {
				setupDates.append(startOfWeek.dayInRelation(offset: (weekNum * 7) + dayNum))
			}
			days.append(setupDates)
		}
		return days
	}
	
	func setupViews() {
		let today = Date.today
		let dates = self.dates
		
		self.startOfWeek = today.dayInRelation(offset: -(today.dayOfWeek))
		
		for weekIndex in 0..<dates.count {
			let week = dates[weekIndex];
			let weekStack = self.weekStackList[weekIndex]
			
			for dayIndex in 0..<week.count {
				let day = week[dayIndex]

				if let button = weekStack.arrangedSubviews[dayIndex] as? UIButton {
					button.tag = weekIndex * 7 + dayIndex
					button.addTarget(self, action: #selector(self.dayButtonClicked(_:)), for: .touchUpInside)
					
					button.setTitle("\(day.day)", for: .normal)
					
					if let label = button.titleLabel {
						if day.webSafeDate == today.webSafeDate {
							button.setTitleColor(Scheme.blue.color, for: .normal)
							label.font = UIFont.systemFont(ofSize: 16.0, weight: .heavy)
						} else if day.month != today.month {
							button.setTitleColor(Scheme.lightText.color, for: .normal)
							label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
						} else {
							button.setTitleColor(Scheme.text.color, for: .normal)
							label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
						}
					}
				}
			}
		}
	}
	
	@objc func dayButtonClicked(_ sender: UIButton) {
		let tag = sender.tag
		let date = self.startOfWeek.dayInRelation(offset: tag)
		
		self.controller.openDay(date: date)
	}
	
}
