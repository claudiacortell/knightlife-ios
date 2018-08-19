//
//  LoadingModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class LoadingModule: TableModule {
	
	let table: UITableView
	
	init(table: UITableView) {
		self.table = table
		
		super.init()
	}
	
	override func build() {
		let section = self.addSection()
		section.addCell(LoadingCell()).setHeight(self.table.frame.height)
	}
	
}
