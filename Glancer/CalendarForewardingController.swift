//
//  CalendarForewardingController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/28/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class CalendarForewardingController: UIViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		if Globals.getData("push today") == nil
		{
			Globals.setData("push today", data: true)
			if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DayViewController") as? BlockViewController
			{
				controller.date = TimeUtils.todayEnscribed
				controller.todayView = true
				self.navigationController?.pushViewController(controller, animated: false)
			}
		}
	}
}
