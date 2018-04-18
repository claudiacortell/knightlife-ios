//
//  WebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Alamofire
import UnboxedAlamofire
import Unbox

class WebCall<DataContainer: WebCallResult, Result>
{	
	let url: String
	let call: String
	private(set) var parameters: [String: Any]
	
	var callback: (FetchError?, Result?) -> Void = {_,_ in}
	
	init(url: String? = nil, call: String) {
		self.url = url ?? WebCall.baseUrl
		self.call = call
		self.parameters = [:]
	}
	
	func parameter(_ key: String, val: String) {
		self.parameters[key] = val
	}
	
	func passwordParam(val: String) {
		self.parameter("pw", val: val)
	}
	
	func deviceParam() {
		return self.parameter("dv", val: Globals.DeviceID)
	}
	
	func execute()
	{
		let call = self.buildCall()
		
        Alamofire.request(call, method: .get).responseObject() { (response: DataResponse<DataContainer>) in
            if let code = response.response?.statusCode
            {
                if code < 200 || code >= 300 // Invalid response
                {
					self.error(type: .remote, body: "Recieved a response code: \(code)")
					return
                }
            }
			
			if let error = response.error
			{
				if error is UnboxError
				{
					self.error(type: .parse, body: (error as! UnboxError).description)
				} else if error is UnboxedAlamofireError
				{
					self.error(type: .parse, body: (error as! UnboxedAlamofireError).description)
				} else
				{
					self.error(type: .unknown, body: error.localizedDescription)
				}
				return
			}
			
			if let data = response.result.value
			{
				let result = self.handleTokenConversion(data)
				self.success(result: result)
				return
			}
			
			self.success(result: nil)
        }
	}
	
	private func success(result: Result?)
	{
		self.handleCall(error: nil, data: result)
		self.callback(nil, result)
	}
	
	private func error(type: FetchErrorCause, body: String)
	{
		print("Web call \(self.buildCall()) failed. \(type): \(body)")
		
		let error = FetchError(type, body)
		self.handleCall(error: error, data: nil)
		self.callback(error, nil)
	}
	
	private func buildCall() -> String
	{
		var name = "\(self.url)\(self.call)"
		
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
	
	func handleCall(error: FetchError?, data: Result?)
	{
		// Override point
	}
	
	func handleTokenConversion(_ data: DataContainer) -> Result?
	{
		// Override point
		return nil
	}
}
