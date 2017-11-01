//
//  WebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Alamofire

class WebCall
{
	let url: String
	let call: String
	
	private(set) var parameters: [String: String]
	
	init(url: String = "https://bbn-knightlife.herokuapp.com/api/", call: String)
	{
		self.url = url
		self.call = call
		self.parameters = [:]
	}
	
	func parameter(_ key: String, val: String) -> WebCall // Return self for easy chaining
	{
		self.parameters[key] = val
		return self
	}
	
	func password(val: String) -> WebCall // Fill a call password
	{
		return self.parameter("password", val: val)
	}
	
	func token() -> WebCall // Specify the device token
	{
		return self.parameter("token", val: Device.ID)
	}
	
	func executeSync() -> WebCallResponseToken
	{
		
	}
}
