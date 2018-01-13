//
//  StoryboardCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct TableCell
{
	let reuseId: String
	let callback: (TableCell, UITableViewCell) -> Void
	private(set) var data: [String: Any] = [:]

	private(set) var height: CGFloat?
	
	init(_ reuseId: String, callback: @escaping (TableCell, UITableViewCell) -> Void = {_,_ in})
	{
		self.reuseId = reuseId
		self.callback = callback
	}
	
	mutating func setData(_ key: String, data: Any?)
	{
		self.data[key] = data
	}
	
	func getData(_ key: String) -> Any?
	{
		return self.data[key]
	}
	
	mutating func setHeight(_ height: Int)
	{
		self.height = CGFloat(height)
	}
	
	mutating func setHeight(_ height: CGFloat)
	{
		self.height = height
	}
}
