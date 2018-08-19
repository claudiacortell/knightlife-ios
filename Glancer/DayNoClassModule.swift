//
//  NoClassModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class NoClassModule: TableModule {
	
	let table: UITableView
	let fullHeight: Bool
	
	init(table: UITableView, fullHeight: Bool) {
		self.table = table
		self.fullHeight = fullHeight
		
		super.init()
	}
	
	override func build() {
		let section = self.addSection()
		section.addCell(NoClassCell()).setHeight(self.fullHeight ? self.table.frame.height : 120)
	}
	
}
