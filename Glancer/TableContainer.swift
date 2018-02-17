//
//  StoryboardContainer.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import CoreGraphics

class TableContainer
{
	private(set) var sections: [TableSection] = []
}

extension TableContainer
{
	var sectionCount: Int { get { return sections.count } }

    func getSection(_ id: Int) -> TableSection?
    {
        return self.sections[id]
    }
	
	func addSection(_ section: TableSection)
	{
		self.sections.append(section)
	}
}
