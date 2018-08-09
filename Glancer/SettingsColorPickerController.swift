//
//  SettingsColorPickerController.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import Color_Picker_for_iOS

class SettingsColorPickerController: UIViewController {
	
	@IBOutlet weak var colorPickerView: HRColorPickerView!
	
	var color: UIColor!
	var colorPicked: (UIColor) -> Void = {_ in}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.colorPickerView.addTarget(self, action: #selector(self.didChangeColor(_:)), for: .valueChanged)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.colorPickerView.color = self.color
	}
	
	@objc func didChangeColor(_ sender: HRColorPickerView) {
		self.colorPicked(sender.color)
	}
	
}
