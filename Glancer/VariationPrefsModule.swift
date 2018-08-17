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
	
	override func build() {
		let section = self.addSection()
		section.addDivider()
		section.addCell(TitleCell(title: "First Lunch"))
		section.addDivider()
		
		for weekday in DayOfWeek.weekdays() {
			let variation = ScheduleManager.instance.getVariation(weekday)
			
			section.addCell(PrefToggleCell(title: weekday.displayName, on: variation == 1) {
				let newVariation = $0 ? 1 : 0
				ScheduleManager.instance.setVariation(day: weekday, variation: newVariation)
			})
			
			section.addDivider()
		}
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
}
