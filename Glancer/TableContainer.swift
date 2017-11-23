//
//  StoryboardContainer.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct TableContainer
{
	var sections: [TableSection] = []
	var sectionCount: Int { get { return sections.count } }
}

extension TableContainer
{
    func getSection(id: Int) -> TableSection?
    {
        return self.sections[id]
    }
}
