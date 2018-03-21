//
//  StoryboardSection.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

class TableSection
{
	private(set) var cells: [TableCell] = []
	
	var title: String?
	var headerHeight: Int?
	var footerHeight: Int?
}

extension TableSection
{
	var cellCount: Int { return cells.count }

	func getCellByIndex(_ id: Int) -> TableCell?
	{
		return self.cells[id]
	}
	
	func addSpacerCell(_ height: Int)
	{
		let cell = TableCell("spacer")
		cell.setHeight(height)
		self.addCell(cell)
	}
	
	func addCell(_ cell: TableCell)
	{
		self.cells.append(cell)
	}
	
	@discardableResult
	func addCell(_ id: String) -> TableCell
	{
		let cell = TableCell(id)
		self.addCell(cell)
		return cell
	}
}
