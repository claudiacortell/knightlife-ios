//
//  LunchPrefsModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/31/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class LunchPrefsModule: TableModule {
	
	func loadCells(layout: TableLayout) {
		let section = layout.addSection()
		section.addDivider()
		section.addCell(TitleCell(title: "Lunch"))
		section.addDivider()
		section.addCell(LunchPrefsCell(module: self, show: LunchManager.instance.showAllergens))
		section.addDivider()
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	func valueChanged(bool: Bool) {
		LunchManager.instance.setShowAllergens(value: bool)
	}
	
}
