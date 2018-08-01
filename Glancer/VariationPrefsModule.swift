//
//  VariationPrefsModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/31/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class VariationPrefsModule: TableModule {
	
	func loadCells(layout: TableLayout) {
		let section = layout.addSection()
		section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		section.addCell(TitleCell(title: "First Lunch"))
		section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		
		for weekday in DayOfWeek.weekdays() {
			let variation = ScheduleManager.instance.getVariation(weekday)
			section.addCell(VariationPrefCell(module: self, weekday: weekday, variation: variation))
			section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		}
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	func valueChanged(weekday: DayOfWeek, variation: Int) {
		ScheduleManager.instance.setVariation(day: weekday, variation: variation)
	}
	
}
