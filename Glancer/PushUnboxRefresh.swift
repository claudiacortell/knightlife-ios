//
//  PushUnboxRefresh.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Unbox

struct PushUnboxRefresh: Unboxable {
	
	let date: Date
	let target: PushRefreshType
	
	init(unboxer: Unboxer) throws {
		let rawDate: String = try unboxer.unbox(key: "date")
		let rawTarget: String = try unboxer.unbox(key: "target")
		
		guard let date = Date.fromWebDate(string: rawDate) else {
			throw UnboxError.invalidData
		}
		
		guard let target = PushRefreshType(rawValue: rawTarget) else {
			throw UnboxError.invalidData
		}
		
		self.date = date
		self.target = target
	}
	
}
