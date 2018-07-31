//
//  LoadingCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/29/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class LoadingCell: TableCell {
	
	init() {
		super.init("loading", nib: "LoadingCell")
		
		self.setSelectionStyle(.none)
		self.setCallback() {
			template, cell in
			
			guard let loading = cell as? UILoadingCell else {
				return
			}
			
			cell.backgroundColor = .clear
			loading.loadingIcon.layer.opacity = 0.1
			loading.loadingLabel.layer.opacity = 0.1
			
			UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
				loading.loadingIcon.layer.opacity = 0.4
				loading.loadingLabel.layer.opacity = 0.4
			}, completion: nil)
		}
	}
	
}

class UILoadingCell: UITableViewCell {
	
	@IBOutlet weak var loadingIcon: UIImageView!
	@IBOutlet weak var loadingLabel: UILabel!
	
}
