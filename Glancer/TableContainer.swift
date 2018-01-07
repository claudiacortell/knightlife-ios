//
//  StoryboardContainer.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import CoreGraphics

struct TableContainer
{
	var sections: [TableSection] = []
	var sectionCount: Int { get { return sections.count } }
}

extension TableContainer
{
    func getSection(_ id: Int) -> TableSection?
    {
        return self.sections[id]
    }
	
	func getCell(_ id: Int) -> TableCell?
	{
		for section in self.sections
		{
			if let cell = section.getCellByID(id)
			{
				return cell
			}
		}
		return nil
	}
	
	func setHeight(_ cell: TableCell, height: CGFloat)
	{
		setHeight(cell.id, height: height)
	}
	
	func setHeight(_ id: Int, height: CGFloat)
	{
		if var cell = getCell(id)
		{
			cell.height = CGFloat(height)
		}
	}
}
