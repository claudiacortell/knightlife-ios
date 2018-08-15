//
//  NothingUpcomingCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/14/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class NothingUpcomingCell: TableCell {
	
	init() {
		super.init("nothingupcoming", nib: "NothingUpcomingCell")
		
		self.setSelectionStyle(.none)
		
		self.setCallback() {
			template, cell in
			
			cell.backgroundColor = .clear
		}
	}
	
}

class UINothingUpcomingCell: UITableViewCell {
	
	
	
}
