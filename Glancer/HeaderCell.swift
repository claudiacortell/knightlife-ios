//
//  HeaderCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 6/2/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore
import UIKit

class HeaderCell: TableCell {
	
	var header: String?
	var subtitle: String?
	var showMore: Bool = false
	var moreLabel: String = "More..."
	
	init(header: String, subtitle: String?, more: String?) {
		super.init("headerCell", nib: "HeaderCell", bundle: Bundle(identifier: "MAD.BBN.KnightLife"))
		
		self.setSelection(.none)
		
		self.header = header
		self.subtitle = subtitle
		self.showMore = more != nil
		if more != nil { self.moreLabel = more! }
		
		self.setHeight(35)
		self.setCallback() {
			template, cell in
			
			cell.selectionStyle = .none
			
			if let headerCell = cell as? HeaderCell {
				headerCell.header = self.header
				headerCell.subtitle = self.subtitle
				headerCell.showMore = self.showMore
				headerCell.moreLabel = self.moreLabel
			}
		}
	}
	
}

class UIHeaderCell: UITableViewCell {
	
	@IBOutlet weak private var headerLabel: UILabel!
	@IBOutlet weak private var subtitleLabel: UILabel!
	@IBOutlet weak private var moreButton: UIButton!
	
	var header: String? {
		didSet {
			self.headerLabel.text = header
		}
	}
	
	var subtitle: String? {
		didSet {
			self.subtitleLabel.text = subtitle
		}
	}
	
	var showMore: Bool = false {
		didSet {
			self.moreButton.isHidden = !showMore
		}
	}
	
	var moreLabel: String = "More..." {
		didSet {
			self.moreButton.setTitle(self.moreLabel, for: .normal)
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.header = nil
		self.subtitle = nil
		self.showMore = false
		self.moreLabel = "More..."
	}
	
}
