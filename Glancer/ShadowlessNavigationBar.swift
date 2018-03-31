//
//  ShadowlessNavigationBar.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/21/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class NavigationBarController: UINavigationController, UINavigationControllerDelegate
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationBar.shadowImage = UIImage()
				
		self.buildTitle()
	}
	
	private func buildTitle()
	{
		var label = UILabel()
		label.text = "TESTSETSETSE"
		label.setContentHuggingPriority(.required, for: .vertical)
		label.setContentCompressionResistancePriority(.required, for: .vertical)
//
//		label.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self.navigationBar, attribute: .leading, multiplier: 1.0, constant: 15.0))
//		label.addConstraint(NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self.navigationBar, attribute: .bottom, multiplier: 1.0, constant: 12.0))
//		label.addConstraint(NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self.navigationBar, attribute: .trailing, multiplier: 1.0, constant: 15.0))
//
		self.navigationBar.insertSubview(label, at: 0)
		
		for view in navigationBar.subviews
		{
			print(view)
		}

//		navigationBar.subview
	}
}
