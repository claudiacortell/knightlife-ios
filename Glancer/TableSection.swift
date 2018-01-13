//
//  StoryboardSection.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct TableSection
{
	private(set) var cells: [TableCell] = []
	
	var title: String?
	var headerHeight: Int?
	var footerHeight: Int?
	
    var cellCount: Int { return cells.count }
}

extension TableSection
{
	init(_ title: String)
	{
		self.title = title
	}
	
	mutating func addCell(_ cell: TableCell)
	{
		self.cells.append(cell)
	}
	
	func getCellByIndex(_ id: Int) -> TableCell?
	{
		return self.cells[id]
	}
}
