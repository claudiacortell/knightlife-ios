//
//  ResourceHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 2/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class ResourceHandler<Payload>
{
	private var successCallbacks: [String: (Payload?) -> Void] = [:]
	private var failureCallbacks: [String: (FetchError) -> Void] = [:]
	
	func registerSuccessCallback(_ id: String, _ callback: @escaping (Payload?) -> Void)
	{
		self.successCallbacks[id] = callback
	}
	
	func registerFailureCallback(_ id: String, _ callback: @escaping (FetchError) -> Void)
	{
		self.failureCallbacks[id] = callback
	}
	
	func removeSuccessCallback(_ id: String)
	{
		self.successCallbacks.removeValue(forKey: id)
	}
	
	func removeFailureCallback(_ id: String)
	{
		self.failureCallbacks.removeValue(forKey: id)
	}

	func success(_ data: Payload?)
	{
		for callback in self.successCallbacks.values
		{
			callback(data)
		}
	}
	
	func failure(_ error: FetchError)
	{
		for callback in self.failureCallbacks.values
		{
			callback(error)
		}
	}
}
