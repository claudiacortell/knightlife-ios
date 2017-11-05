//
//  Storyboardable.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/5/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

protocol Storyboardable
{
	var storyboardContainer: StoryboardContainer? { get set }
	func generateContainer()
}
