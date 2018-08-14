//
//  SettingsController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/29/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import SafariServices

class SettingsController: UIViewController, TableBuilder {
	
	@IBOutlet weak var tableView: UITableView!
	private(set) var tableHandler: TableHandler!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.builder = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
	}
	
	func buildCells(layout: TableLayout) {
		self.tableHandler.addModule(CoursesPrefModule(controller: self))
		self.tableHandler.addModule(BlockPrefsModule(controller: self))
		self.tableHandler.addModule(VariationPrefsModule())
		self.tableHandler.addModule(EventsPrefsModule(controller: self))
		self.tableHandler.addModule(LunchPrefsModule())
		self.tableHandler.addModule(BottomPrefsModule())
	}
	
	@IBAction func surveyClicked(_ sender: Any) {
		if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			SurveyWebCall(version: text).callback() {
				result in
				
				switch result {
				case .success(let url):
					let safariController = SFSafariViewController(url: url)
					self.present(safariController, animated: true, completion: nil)
				default:
					let alertController = UIAlertController(title: "Error", message: "Couldn't fetch the survey", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
					self.present(alertController, animated: true, completion: nil)
				}
			}.execute()
		}
	}
	
}
