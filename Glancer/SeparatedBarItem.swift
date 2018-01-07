//
//  SeparatedBarItem.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/7/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class SeparatedBarItem: UINavigationBar
{
	private let height = 1
	
	override func layoutSubviews()
	{
		super.layoutSubviews()
		
		let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: CGFloat(self.height))
		let bottomBorderView = UIView(frame: bottomBorderRect)
		
		bottomBorderView.backgroundColor = UIColor("0A4FA8")
		addSubview(bottomBorderView)
	}
}
