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
    var cells: [TableCell] = []
	
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
	
	func getCell(_ id: Int) -> TableCell?
	{
		return self.cells[id]
	}
	
    func getCellByID(_ id: Int) -> TableCell?
    {
		for cell in self.cells
		{
			if cell.id == id
			{
				return cell
			}
		}
		
		return nil
	}
}
