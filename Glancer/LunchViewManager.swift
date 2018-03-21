//
//  LunchViewManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/21/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Presentr
import UIKit

class LunchViewManager
{
	let presentr: Presentr =
	{
		let newObject = Presentr(presentationType: .popup)
		
		newObject.transitionType = .coverVertical
		newObject.dismissTransitionType = .crossDissolve
		
		newObject.roundCorners = true
		newObject.cornerRadius = 12
		
		newObject.dismissOnSwipe = true
		
		return newObject
	}()
}
