//
//  ErrorCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/29/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class ErrorCell: TableCell {
	
	var reload: ErrorReloadable
	
	init(reloadable: ErrorReloadable) {
		self.reload = reloadable
		
		super.init("error", nib: "ErrorCell")
		
		self.setSelectionStyle(.none)
		
		self.setSelection() {
			template, cell in
			
			self.reload.reloadData()
		}
		
		self.setCallback() {
			template, cell in
			
			cell.backgroundColor = UIColor.clear
		}
	}
	
}

class UIErrorCell: UITableViewCell {
	
	
	
}
