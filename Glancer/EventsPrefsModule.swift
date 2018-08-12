//
//  EventsPrefsModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/11/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

class EventsPrefsModule: TableModule {
	
	let controller: SettingsController
	
	init(controller: SettingsController) {
		self.controller = controller
	}
	
	func loadCells(layout: TableLayout) {
		let section = layout.addSection()
		section.addDivider()
		section.addCell(TitleCell(title: "Events"))
		section.addDivider()
		
		section.addCell(SettingsTextCell(left: "Your Grade", right: EventManager.instance.userGrade.settingsDisplayName) {
			self.showChangeGrade()
		})
		
		section.addDivider()
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	private func showChangeGrade() {
		let alert = UIAlertController(title: "Grade", message: "Setting this ensures you will only see events that are relevant to you.", preferredStyle: .actionSheet)
		
		//		Array of tuples instead of dictionary so that it retains its order
		var blockActions: [(id: Grade, alert: UIAlertAction)] = []
		
		let handler: (UIAlertAction) -> Void = {
			alert in
			
			//			Get the tuple with this specific action, and thus its blockId
			guard let key = blockActions.filter({ $0.alert === alert }).first?.id else {
				return
			}
			
			EventManager.instance.setGrade(grade: key)
			self.controller.tableHandler.reload()
		}
		
		blockActions = [
			(.freshmen, UIAlertAction(title: "Freshman", style: .default, handler: handler)),
			(.sophomores, UIAlertAction(title: "Sophomore", style: .default, handler: handler)),
			(.juniors, UIAlertAction(title: "Junior", style: .default, handler: handler)),
			(.seniors, UIAlertAction(title: "Senior", style: .default, handler: handler)),
			(.allSchool, UIAlertAction(title: "Not Set", style: .default, handler: handler)),
		]
		
		for (id, action) in blockActions {
			if EventManager.instance.userGrade == id {
				action.setValue(true, forKey: "checked")
			}
			
			alert.addAction(action)
		}
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.controller.present(alert, animated: true)
	}
	
}
