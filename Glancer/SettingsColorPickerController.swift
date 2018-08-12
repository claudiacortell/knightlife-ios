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

class SettingsColorPickerController: UIViewController {
	
	var color: UIColor!
	var colorPicked: (UIColor) -> Void = {_ in}
	
	var colorViews: [String: SettingsColorView] = [:]
	
	var selected: SettingsColorView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.findColorViews()
		
		if let colorHex = self.color.toHex, let selectedView = self.colorViews[colorHex] {
			selectedView.select()
			self.selected = selectedView
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	private func findColorViews(_ find: UIView? = nil) {
		let view = find ?? self.view
		
		if let colorView = view as? SettingsColorView, !self.colorViews.values.contains(colorView) {
			colorView.controller = self
			self.colorViews[colorView.color.toHex ?? ""] = colorView
		}
		
		for subview in view!.subviews {
			self.findColorViews(subview)
		}
	}
	
	func colorPicked(color: UIColor, view: SettingsColorView) {
		if self.selected === view {
			return
		}
		
		if self.selected != nil {
			self.selected!.deselect()
		}
		
		self.selected = view
		self.colorPicked(color)
	}
	
}
