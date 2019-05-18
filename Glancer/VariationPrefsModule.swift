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
			let variation = Schedule.firstLunches[weekday]!
							
			section.addCell(PrefToggleCell(title: weekday.displayName, on: variation) {
				Schedule.firstLunches[weekday] = $0
			})
			
			section.addDivider()
		}
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
}
