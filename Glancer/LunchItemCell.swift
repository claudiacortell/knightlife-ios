//
//  LunchItemCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class LunchItemCell: TableCell {
	
	init(item: LunchMenuItem) {
		super.init("item", nib: "LunchItemCell")
		
		self.setEstimatedHeight(45)
		self.setSelectionStyle(.none)
		
		self.setCallback() {
			template, cell in
			
			guard let lunchCell = cell as? UILunchItemCell else {
				return
			}
			
			lunchCell.nameLabel.text = item.name
			
			for view in lunchCell.attachmentsStack.arrangedSubviews { lunchCell.attachmentsStack.removeArrangedSubview(view) ; view.removeFromSuperview() }
			
			if let allergy = item.allergy {
				let attachment = LunchItemAttachmentView()
				attachment.text = allergy
				lunchCell.attachmentsStack.addArrangedSubview(attachment)				
			}
			
			lunchCell.attachmentsBottomConstraint.constant = lunchCell.attachmentsStack.arrangedSubviews.count > 0 ? 10.0 : 0.0
		}
	}
	
}

class UILunchItemCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	
	@IBOutlet weak var attachmentsStack: UIStackView!
	@IBOutlet weak var attachmentsBottomConstraint: NSLayoutConstraint!
	
}
