//
//  Refreshable.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/4/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyJSON
import Signals

protocol Refreshable {
	
	// Signal to listen for refreshes
	var onUpdate: Signal<Self> { get }
	
	// Call to refresh
	func refresh() -> CallbackSignal<Self>
	
	// Function to copy data over from newer instance
	func updateContent(from: Self)
	
}
