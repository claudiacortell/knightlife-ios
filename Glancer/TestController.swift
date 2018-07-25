//
//  TestController.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/14/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

class TestController: UIViewController {
	
	@IBOutlet weak var tableReference: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableReference.contentInset = UIEdgeInsets(top: 79, left: 0, bottom: 0, right: 0)
		self.tableReference.contentOffset = CGPoint(x: 0.0, y: -self.tableReference.contentInset.top)
	}
}
