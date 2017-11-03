//
//  WebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Alamofire

class WebCall<DataContainer>: WebDataResponseHandler<DataContainer>
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
	
	@discardableResult
	func parameter(_ key: String, val: String) -> WebCall // Return self for easy chaining
	{
		self.parameters[key] = val
		return self
	}
	
	@discardableResult
	func password(val: String) -> WebCall // Fill a call password
	{
		return self.parameter("password", val: val)
	}
	
	@discardableResult
	func token() -> WebCall // Specify the device token
	{
		return self.parameter("token", val: Device.ID)
	}
	
	func execute(_ handler: WebCallHandler<DataContainer>, dataHandler: WebDataResponseHandler<DataContainer>? = nil)
	{
		let call = self.buildCall()
		
		Alamofire.request(call).responseJSON
		{ response in
			if let error = response.error
			{
				handler.handleCall(url: self.url, call: self.call, completeCall: call, success: false, error: error.localizedDescription, data: nil)
				return
			}
			
			if let code = response.response?.statusCode
			{
				if code < 200 || code >= 300 // Invalid response
				{
					handler.handleCall(url: self.url, call: self.call, completeCall: call, success: false, error: "Invalid HTTP response: \(code)", data: nil)
					return
				}
			}
			
			if let data = response.data
			{
				handler.handleCall(url: self.url, call: self.call, completeCall: call, success: true, error: nil, data: (dataHandler == nil ? self.handleData(data: data) : dataHandler!.handleData(data: data)))
				return
			}
			
			handler.handleCall(url: self.url, call: self.call, completeCall: call, success: false, error: "Unknown error", data: nil)
		}
	}
	
	private func buildCall() -> String
	{
		var name = "\(self.url + self.call)/"
		
		if self.parameters.count > 0
		{
			name += "?"
			for (key, val) in self.parameters
			{
				name += "\(key)=\(val)&"
			}
			name = String(name.dropLast())
		}
		return name
	}
}
