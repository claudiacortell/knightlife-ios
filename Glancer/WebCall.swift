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

protocol WebCallExecutable
{
	func execute()
}

class WebCall<WebCallManager: Manager, DataContainer: WebCallResult, Result>: WebCallHandler<WebCallManager, DataContainer, Result>, WebCallExecutable
{
	private var handler: WebCallHandler<WebCallManager, DataContainer, Result>!
	private let converter: WebCallResultConverter<WebCallManager, DataContainer, Result>?
	
	private let fetchToken: ResourceFetchToken?
	private var callbacks: [(ResourceFetch<Result>) -> Void]
	
	let url: String
	let call: String
	
	private(set) var parameters: [String: String]
	
	init(manager: WebCallManager, handler: WebCallHandler<WebCallManager, DataContainer, Result>? = nil, converter: WebCallResultConverter<WebCallManager, DataContainer, Result>? = nil, fetchToken: ResourceFetchToken? = nil, url: String = "https://bbn-knightlife.herokuapp.com/api/", call: String)
	{
		self.converter = converter
		
		self.fetchToken = fetchToken
		self.callbacks = []
		
		self.url = url
		self.call = call
		self.parameters = [:]
		
		super.init(manager: manager)
		
		self.handler = handler ?? self
	}
	
	private func convert(_ data: DataContainer) -> Result?
	{
		if self.converter != nil
		{
			if self.converter!.webCall == nil
			{
				self.converter!.webCall = self // Set the web call to self to make sure it's fine
			}
			return self.converter!.convert(data)
		}
		manager.out("It appears you tried to convert a webcall result without a converter!")
		return nil
	}
	
	final func addCallback(_ callback: @escaping (ResourceFetch<Result>) -> Void)
	{
		self.callbacks.append(callback)
	}
	
	@discardableResult
	final func parameter(_ key: String, val: String) -> WebCall // Return self for easy chaining
	{
		self.parameters[key] = val
		return self
	}
	
	@discardableResult
	final func password(val: String) -> WebCall // Fill a call password
	{
		return self.parameter("password", val: val)
	}
	
	@discardableResult
	final func device() -> WebCall // Specify the device token
	{
		return self.parameter("device", val: Device.ID)
	}
	
	func execute()
	{
		let call = self.buildCall()
		
        Alamofire.request(call, method: .get).responseObject() { (response: DataResponse<DataContainer>) in
            if let error = response.error
            {
				var madeConnection = false
				var errorBody: String = error.localizedDescription
				if error is UnboxError
				{
					errorBody = (error as! UnboxError).description
					madeConnection = true
				} else if error is UnboxedAlamofireError
				{
					errorBody = (error as! UnboxedAlamofireError).description
					madeConnection = true
				}
				
                self.handler.handleCall(url: self.url, call: self.call, completeCall: call, success: false, error: errorBody, data: nil)
				self.doCallbacks(nil, fetch: .error, madeConnection: madeConnection)
                return
            }
            
            if let code = response.response?.statusCode
            {
                if code < 200 || code >= 300 // Invalid response
                {
                    self.handler.handleCall(url: self.url, call: self.call, completeCall: call, success: false, error: "Invalid HTTP response: \(code)", data: nil)
					self.doCallbacks(nil, fetch: .failure, madeConnection: false)
                    return
                }
            }
            
            if let data = response.result.value
            {
				let result = self.convert(data)
                self.handler.handleCall(url: self.url, call: self.call, completeCall: call, success: true, error: nil, data: result)
				self.doCallbacks(result, fetch: .success, madeConnection: true)
                return
            }
            
            self.handler.handleCall(url: self.url, call: self.call, completeCall: call, success: false, error: "Unknown error", data: nil)
			self.doCallbacks(nil, fetch: .error, madeConnection: false)
        }
	}
	
	private func doCallbacks(_ result: Result?, fetch: ResourceFetchResult, madeConnection: Bool)
	{
		if !self.callbacks.isEmpty
		{
			if self.fetchToken == nil
			{
				self.manager.out("Attempted to perform a WebCall callback without a fetch token set!")
				return
			}
			
			let fetch = ResourceFetch(self.fetchToken!, fetch, result, madeConnection)
			
			for callback in self.callbacks
			{
				callback(fetch)
			}
		}
	}
	
	private func buildCall() -> String
	{
		var name = "\(self.url + self.call)"
		
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
