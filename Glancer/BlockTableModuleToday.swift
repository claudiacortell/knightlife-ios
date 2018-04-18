//
//  BlockTableModuleToday.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

class BlockTableModuleToday: TableModule
{
	let controller: BlockViewController
	
	init(controller: BlockViewController)
	{
		self.controller = controller
	}
	
	func loadCells(form: TableForm)
	{
		let section = form.addSection()
		
		section.addSpacerCell().setHeight(10)
		
		section.addCell("today_now").setHeight(35)
		section.addCell("today_next").setHeight(25)

		section.addSpacerCell().setHeight(10)

		section.addCell("today_now_label").setHeight(20)
		section.addCell("today_progress").setHeight(3)
	
		section.addSpacerCell().setHeight(15)
	}
}
