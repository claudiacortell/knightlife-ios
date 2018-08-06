//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import UIKit
import NotificationCenter
import AddictiveLib

class TodayViewController: UIViewController, NCWidgetProviding {
	
	private var state: TodayManager.TodayScheduleState? // Null if error
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_ = TodayManager.instance
		self.handleStateChange(state: TodayManager.instance.currentState)
	}
	
	private func registerListener() {
		TodayManager.instance.statusWatcher.onSuccess(self) {
			state in
			
			self.handleStateChange(state: state)
		}
		
		TodayManager.instance.statusWatcher.onFailure(self) {
			error in
			
			self.handleStateChange(state: nil)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		TodayManager.instance.startTimer()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		TodayManager.instance.stopTimer()
	}
	
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		TodayManager.instance.reloadTodayBundle()
		completionHandler(NCUpdateResult.newData)
	}
	
	private func handleStateChange(state: TodayManager.TodayScheduleState?) {
		self.state = state
		self.updateViews()
	}
	
	@IBAction func openContainingApp(_ sender: Any) {
		self.extensionContext?.open(URL(string: "MAD.BBN.KnightLife.URL.OpenApp://")!, completionHandler: nil)
	}
	
	private func updateViews() {
		guard let state = self.state else {
			//			Show error
			return
		}
	}
	
}
