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

class SettingsController: UIViewController, TableHandlerDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	private(set) var tableHandler: TableHandler!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
	}
	
	func buildCells(handler: TableHandler, layout: TableLayout) {
		layout.addModule(CoursesPrefModule(controller: self))
		layout.addModule(BlockPrefsModule(controller: self))
		layout.addModule(VariationPrefsModule())
		layout.addModule(EventsPrefsModule(controller: self))
		layout.addModule(LunchPrefsModule())
		layout.addModule(BottomPrefsModule())
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
