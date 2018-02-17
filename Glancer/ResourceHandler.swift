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
	private var successCallbacks: [(Payload?) -> Void] = []
	private var failureCallbacks: [(FetchError) -> Void] = []
	
	func registerSuccessCallback(_ callback: @escaping (Payload?) -> Void)
	{
		self.successCallbacks.append(callback)
	}
	
	func registerFailureCallback(_ callback: @escaping (FetchError) -> Void)
	{
		self.failureCallbacks.append(callback)
	}
	
	func success(_ data: Payload?)
	{
		for callback in self.successCallbacks
		{
			callback(data)
		}
	}
	
	func failure(_ error: FetchError)
	{
		for callback in self.failureCallbacks
		{
			callback(error)
		}
	}
}
