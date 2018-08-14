//
//  BottomPrefsModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/14/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class BottomPrefsModule: TableModule {
	
	func loadCells(layout: TableLayout) {
		let section = layout.addSection()
		
		section.addCell("survey").setHeight(35)
		section.addCell("credits").setHeight(35)
		
		section.addSpacerCell().setHeight(20).setSelectionStyle(.none)
	}
	
}
