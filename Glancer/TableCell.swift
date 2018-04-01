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

class TableCell
{
	let reuseId: String
	let callback: (TableCell, UITableViewCell) -> Void
	
	private(set) var data: [String: Any] = [:]

	var height: CGFloat?
	
	init(_ reuseId: String, callback: @escaping (TableCell, UITableViewCell) -> Void = {_,_ in})
	{
		self.reuseId = reuseId
		self.callback = callback
	}
	
	@discardableResult
	func setData(_ key: String, data: Any?) -> TableCell
	{
		self.data[key] = data
		return self
	}
	
	func getData(_ key: String) -> Any?
	{
		return self.data[key]
	}
	
	@discardableResult
	func setHeight(_ float: CGFloat) -> TableCell
	{
		self.height = float
		return self
	}
	
	@discardableResult
	func setHeight(_ int: Int) -> TableCell
	{
		self.height = CGFloat(int)
		return self
	}
}
