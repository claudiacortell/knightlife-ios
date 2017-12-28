//
//  ResourceFetchResponse.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/20/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

enum ResourceFetchResult
{
	case
	success,
	failure
}

class ResourceFetch<Object> // Used for callback data
{
	let token: ResourceFetchToken
	let result: ResourceFetchResult
	let madeConnection: Bool?
	let data: Object?
	
	var hasData: Bool { return data != nil }
	
	init(_ token: ResourceFetchToken, _ result: ResourceFetchResult, _ data: Object?, _ madeConnection: Bool? = nil)
	{
		self.token = token
		self.result = result
		self.data = data
		self.madeConnection = madeConnection
	}
}

struct ResourceFetchToken // Used to store fetch data and save ID's of resource fetches. An identical one is returned with every resource fetch.
{
	let id: String
	
	init()
	{
		self.id = UUID().uuidString
	}
}

extension ResourceFetchToken: Hashable
{
	var hashValue: Int
	{
		return self.id.hashValue
	}
	
	static func ==(lhs: ResourceFetchToken, rhs: ResourceFetchToken) -> Bool
	{
		return lhs.id == rhs.id
	}
}
