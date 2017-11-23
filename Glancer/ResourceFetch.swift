//
//  ResourceFetchResponse.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/20/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

enum ResourceFetchResponse
{
	case
	none, // NEver used
	localFetch,
	remoteFetch
}

enum ResourceFetchResult
{
	case
	success,
	error,
	failure
}

class ResourceFetch<Object> // Used for callback data
{
	let token: ResourceFetchToken
	let result: ResourceFetchResult
	let data: Object?
	
	var hasData: Bool { return data != nil }
	
	init(_ token: ResourceFetchToken, _ result: ResourceFetchResult, _ data: Object?)
	{
		self.token = token
		self.result = result
		self.data = data
	}
}

struct ResourceFetchToken // Used to store fetch data and save ID's of resource fetches. An identical one is returned with every resource fetch.
{
	let response: ResourceFetchResponse
	let id: String
	
	init(_ response: ResourceFetchResponse)
	{
		self.response = response
		self.id = UUID().uuidString
	}
}

extension ResourceFetchToken: Hashable
{
	var hashValue: Int
	{
		return self.response.hashValue ^ self.id.hashValue
	}
	
	static func ==(lhs: ResourceFetchToken, rhs: ResourceFetchToken) -> Bool
	{
		return lhs.response == rhs.response && lhs.id == rhs.id
	}
}
