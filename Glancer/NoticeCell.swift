//
//  NoticeCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class NoticeCell: TableCell {
	
	init(notice: DateNotice) {
		super.init("notice", nib: "NoticeCell")
		
		self.setEstimatedHeight(40)
		self.setSelectionStyle(.none)
		
		self.setCallback() {
			template, cell in
			
			guard let cell = cell as? UINoticeCell else {
				return
			}
			
			for view in cell.attachmentStack.arrangedSubviews { view.removeFromSuperview() }
			
			let attachment = NoticeAttachmentView()
			attachment.notice = notice
			cell.attachmentStack.addArrangedSubview(attachment)
		}
	}
	
}

class UINoticeCell: UITableViewCell {
	
	@IBOutlet weak var attachmentStack: UIStackView!
	
}
