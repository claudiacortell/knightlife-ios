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
	
	override func build() {
		let section = self.addSection()
		section.addDivider()
		section.addCell(TitleCell(title: "Grade"))
		section.addDivider()
		
		section.addCell(SettingsTextCell(left: "Your Grade", right: Grade.userGrade == nil ? "Not Set" : Grade.userGrade!.singular) {
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
			
			//			Get the tuple with this specific action, and thus its Block.ID
			guard let key = blockActions.filter({ $0.alert === alert }).first?.id else {
				return
			}
			
			Grade.userGrade = key
			self.controller.tableHandler.reload()
		}
		
		blockActions = [
			(.freshmen, UIAlertAction(title: "Freshman", style: .default, handler: handler)),
			(.sophomores, UIAlertAction(title: "Sophomore", style: .default, handler: handler)),
			(.juniors, UIAlertAction(title: "Junior", style: .default, handler: handler)),
			(.seniors, UIAlertAction(title: "Senior", style: .default, handler: handler))
		]
		
		// Set normal grade values to be checked
		for (id, action) in blockActions {
			if Grade.userGrade == id {
				action.setValue(true, forKey: "checked")
			}
			
			alert.addAction(action)
		}
		
		// Set no grade set action to be checked
		let nullAction = UIAlertAction(title: "Not Set", style: .default, handler: handler)
		
		if Grade.userGrade == nil {
			nullAction.setValue(true, forKey: "checked")
		}
		
		alert.addAction(nullAction)
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.controller.present(alert, animated: true)
	}

}
