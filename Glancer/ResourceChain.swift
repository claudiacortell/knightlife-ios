//
//  ResourceChain.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class ResourceChain
{
	var chain: [(ResourceChain) -> Void]
	
	let success: () -> Void
	let failure: () -> Void
	
	private(set) var started = false
	
	init(success: @escaping () -> Void, failure: @escaping () -> Void)
	{
		self.chain = []
		
		self.success = success
		self.failure = failure
	}
	
	func addLink(_ link: @escaping (ResourceChain) -> Void)
	{
		self.chain.append(link)
	}
	
	func start()
	{
		if !self.started
		{
			self.started = true
			nextLink(true)
		}
	}
	
	func nextLink(_ success: Bool)
	{
		if !success
		{
			self.failure()
			return
		}
		
		if !self.chain.isEmpty
		{
			let link = self.chain.removeFirst()
			link(self)
		} else
		{
			self.success()
		}
	}
}
