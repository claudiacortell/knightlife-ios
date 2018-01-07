//
//  StoryboardCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import CoreGraphics

struct TableCell
{
	let reuseId: String
	let id: Int
	
	var height: CGFloat?
	
	init(_ reuseId: String, id: Int, height: CGFloat? = nil)
	{
		self.reuseId = reuseId
		self.id = id
		
		self.height = height
	}
}
