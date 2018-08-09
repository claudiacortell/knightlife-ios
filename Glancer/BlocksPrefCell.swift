//
//  BlocksPrefCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

class BlocksPrefCell: TableCell {
	
	init(module: BlockPrefsModule, meta: BlockMeta) {
		super.init("blockspref", nib: "BlocksPrefCell")
		
		self.setHeight(44)
		
		self.setSelection() {
			_, _ in
			module.selected(meta: meta)
		}
		
		self.setCallback() {
			template, cell in
			
			guard let prefCell = cell as? UIBlocksPrefCell else {
				return
			}
			
			prefCell.titleLabel.text = meta.block.displayName
			prefCell.titleLabel.textColor = meta.color
		}
	}
	
}

class UIBlocksPrefCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	
}
