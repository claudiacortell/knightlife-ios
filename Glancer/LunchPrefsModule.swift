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
	
	override func build() {
		let section = self.addSection()
		
		section.addDivider()
		section.addCell(TitleCell(title: "Lunch"))
		section.addDivider()

		section.addCell(PrefToggleCell(title: "Allergy Warnings", on: LunchManager.instance.showAllergens) {
			LunchManager.instance.setShowAllergens(value: $0)
		})

		section.addDivider()
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
}
