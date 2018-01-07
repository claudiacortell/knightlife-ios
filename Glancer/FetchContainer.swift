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
	
	var status: ResourceStatus
	{
		if self.result == nil
		{
			return .loading
		} else
		{
			return (self.result!.result == .success) ? .loaded : .failed
		}
	}
	
	var data: Object?
	{
		return self.hasData ? self.result!.data! : nil
	}
	
	init(_ fetch: ResourceFetchToken)
	{
		self.fetch = fetch
	}
	
	mutating func setResult(_ result: ResourceFetch<Object>)
	{
		if self.fetch == result.token
		{
			self.result = result
		}
	}
	
	var loading: Bool
	{
		get
		{
			return self.status == .loading
		}
	}
	
	var completed: Bool
	{
		get
		{
			return self.status == .loaded || self.status == .failed
		}
	}
	
	var successful: Bool
	{
		get
		{
			return self.status == .loaded
		}
	}
	
	var hasData: Bool
	{
		get
		{
			return self.successful && self.result!.data != nil
		}
	}
}
