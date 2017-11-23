//
//  FetchContainer.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/22/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct FetchContainer<Object>
{
	let fetch: ResourceFetchToken
	private(set) var result: ResourceFetch<Object>?
	
	init(fetch: ResourceFetchToken)
	{
		self.fetch = fetch
	}
	
	var realCall: Bool
	{
		get
		{
			return self.fetch != .none
		}
	}
	
	mutating func setResult(_ result: ResourceFetch<Object>)
	{
		if fetch == result.token
		{
			self.result = result
		}
	}
	
	var inProgress: Bool
	{
		get
		{
			return self.realCall && !self.completed
		}
	}
	
	var completed: Bool
	{
		get
		{
			return result != nil
		}
	}
	
	var successful: Bool
	{
		get
		{
			return self.completed && result!.result == .success
		}
	}
}
