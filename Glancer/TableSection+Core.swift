//
//  TableSection+Core.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/2/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

extension TableSection {
	
    //creates a divider bar on the screen. used in settings page
	@discardableResult
	func addDivider() -> TableCell {
		return self.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: Scheme.dividerColor.color)
	}
	
}
