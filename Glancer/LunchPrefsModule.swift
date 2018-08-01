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
		section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		section.addCell(TitleCell(title: "Lunch"))
		section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		section.addCell(LunchPrefsCell(module: self, show: LunchManager.instance.showAllergens))
		section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	func valueChanged(bool: Bool) {
		LunchManager.instance.setShowAllergens(value: bool)
	}
	
}
