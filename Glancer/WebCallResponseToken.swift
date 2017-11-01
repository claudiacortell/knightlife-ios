//
//  WebCallResponseToken.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

struct WebCallResponseToken
{
	var success: Bool
	var error: String
	
	//	var data: ?
	
	init(success: Bool, error: String = nil) {
		self.success = success
		self.error = error
	}
}
