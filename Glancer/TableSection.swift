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
    
    var cellCount: Int { get { return cells.count } }
}

extension TableSection
{
    func getCell(_ id: Int) -> TableCell?
    {
        return self.cells[id]
    }
}
