//
//  UpcomingAttachmentCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/11/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import SnapKit

class UpcomingAttachmentCell: TableCell {
	
	var clickHandler: () -> Void = {}
	
	init(attachmentViews: [AttachmentView]) {
		super.init("upcomingattachment", nib: "UpcomingAttachmentCell")
		
		self.setEstimatedHeight(attachmentViews.count * 75)
		
		self.setSelection() {
			template, cell in
			
			self.clickHandler()
		}
		
		self.setCallback() {
			template, cell in
			
			guard let cell = cell as? UIUpcomingAttachmentCell else {
				return
			}
			
			for subview in cell.attachmentStack.arrangedSubviews { subview.removeFromSuperview() }
			
			for view in attachmentViews {
				cell.attachmentStack.addArrangedSubview(view)
			}
		}
	}
	
}

class UIUpcomingAttachmentCell: UITableViewCell {
	
	@IBOutlet weak var attachmentStack: UIStackView!

	override func setSelected(_ selected: Bool, animated: Bool) {
		if !animated {
			self.backgroundColor = selected ? Scheme.backgroundColor.color : .white
			return
		}

		UIView.animate(withDuration: 0.4) {
			self.backgroundColor = selected ? Scheme.backgroundColor.color : .white
		}
	}
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		if !animated {
			self.backgroundColor = highlighted ? Scheme.backgroundColor.color : .white
			return
		}

		UIView.animate(withDuration: 0.4) {
			self.backgroundColor = highlighted ? Scheme.backgroundColor.color: .white
		}
	}
	
}
