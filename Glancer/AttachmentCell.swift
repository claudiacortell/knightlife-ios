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

class AttachmentCell: TableCell {
	
	var clickHandler: () -> Void = {}
	
	init(attachmentViews: [AttachmentView], selectable: Bool = true) {
		super.init("attachment", nib: "AttachmentCell")
		
		self.setEstimatedHeight(attachmentViews.count * 75)
		
		if selectable {
			self.setSelection() {
				template, cell in
				
				self.clickHandler()
			}
		} else {
			self.setSelectionStyle(.none)
		}
		
		self.setCallback() {
			template, cell in
			
			guard let cell = cell as? UIAttachmentCell else {
				return
			}
			
			cell.selectable = selectable
			
			for subview in cell.attachmentStack.arrangedSubviews { subview.removeFromSuperview() }
			
			for view in attachmentViews {
				cell.attachmentStack.addArrangedSubview(view)
			}
		}
	}
	
}

class UIAttachmentCell: UITableViewCell {
	
	@IBOutlet weak var attachmentStack: UIStackView!
	var selectable: Bool = true

	override func setSelected(_ selected: Bool, animated: Bool) {
		if !self.selectable {
			super.setSelected(selected, animated: animated)
			return
		}
		
		if !animated {
			self.backgroundColor = selected ? Scheme.backgroundColor.color : .white
			return
		}

		UIView.animate(withDuration: 0.4) {
			self.backgroundColor = selected ? Scheme.backgroundColor.color : .white
		}
	}
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		if !self.selectable {
			super.setHighlighted(highlighted, animated: animated)
			return
		}
		
		if !animated {
			self.backgroundColor = highlighted ? Scheme.backgroundColor.color : .white
			return
		}

		UIView.animate(withDuration: 0.4) {
			self.backgroundColor = highlighted ? Scheme.backgroundColor.color: .white
		}
	}
	
}
