//
//  ShadowlessNavigationBar.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/21/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class ShadowlessNavigationBar: UINavigationBar
{
	override func layoutSubviews()
	{
		super.layoutSubviews()
		
		self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.shadowImage = UIImage()
	}
}
