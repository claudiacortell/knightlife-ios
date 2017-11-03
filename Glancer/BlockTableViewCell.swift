//
//  BlockTableViewCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

class BlockTableViewCell: UITableViewCell
{
	@IBOutlet weak var activityTable: BlockActivityTableController!
	
	@IBOutlet weak var blockName: UILabel!
	@IBOutlet weak var blockTime: UILabel!
	
	override func didMoveToSuperview()
	{
		super.didMoveToSuperview()
		
		self.activityTable.dataSource = self.activityTable
		self.activityTable.delegate = self.activityTable
	}
}
