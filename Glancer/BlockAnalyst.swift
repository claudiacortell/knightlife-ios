//
//  BlockAnalyst.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

extension Block {
	
	class Analyst {
		
		private let block: Block
		
		init(block: Block) {
			self.block = block
		}
		
		var courses: [Course] {
			return CourseM.getCourses(block: self.block)
		}
		
		var bestCourse: Course? {
			return self.courses.first
		}
		
		var labAssociatedBlock: Block? {
			guard self.block.id == .lab, let previous = self.block.timetable.getBlockBefore(block: self.block) else {
				return nil
			}
			return previous
		}
		
		var annotations: [Block.Annotation] {
			return self.block.annotations
		}
		
		var bestAnnotation: Block.Annotation? {
			return self.block.foremostAnnotation
		}
		
		var displayName: String {
			if self.block.id == .custom {
				// If we have an annotation, we return its message for the Block title
				if let bestAnnotation = self.bestAnnotation {
					return bestAnnotation.title
				} else {
					return block.id.displayName
				}
			}
			
			if let course = self.bestCourse {
				return course.name
			} else {
				guard let previous = self.labAssociatedBlock else {
					if let blockMeta = BlockMetaM.getBlockMeta(block: self.block.id), blockMeta.id == .free {
						return blockMeta.customName ?? self.block.id.displayName
					}
					
					return self.block.id.displayName
				}
				
				//			Logic for if the block is a Lab.
				let previousAnalyst = previous.analyst
				if previousAnalyst.courses.isEmpty {
					let previousNameBase: String = {
						if let previousMeta = BlockMetaM.getBlockMeta(block: previous.id), previousMeta.id == .free {
							return previousMeta.customName ?? previous.id.shortName
						}
						return previous.id.shortName
					}()
					
					return "\(previousNameBase) \(self.block.id.displayName)"
				} else {
					return "\(previousAnalyst.displayName) \(self.block.id.displayName)"
				}
			}
		}
		
		var color: UIColor {
			if let annotation = self.bestAnnotation, let color = annotation.color {
				return color
			}
			
			if let course = self.bestCourse {
				return course.color
			}
			
			if let previous = self.labAssociatedBlock {
				let previousAnalyst = previous.analyst
				return previousAnalyst.color
			}
			
			if let blockMeta = BlockMetaM.getBlockMeta(block: self.block.id) {
				return blockMeta.color
			}
			
			return Scheme.nullColor.color
		}
		
		var location: String? {
			if let annotation = self.bestAnnotation, let location = annotation.location {
				return location
			}
			
			if let course = self.bestCourse {
				return course.location
			}
			
			return nil
		}
		
		var shouldShowBeforeClassNotifications: Bool {
			if let course = self.bestCourse {
				return course.beforeClassNotifications
			}
			
			if let blockMeta = BlockMetaM.getBlockMeta(block: self.block.id) {
				return blockMeta.beforeClassNotifications
			}
			
			if let labPrevious = self.labAssociatedBlock {
				let previousAnalyst = labPrevious.analyst
				return previousAnalyst.shouldShowBeforeClassNotifications
			}
			
			return true
		}
		
		var shouldShowAfterClassNotifications: Bool {
			if let course = self.bestCourse {
				return course.afterClassNotifications
			}
			
			if let blockMeta = BlockMetaM.getBlockMeta(block: self.block.id) {
				return blockMeta.afterClassNotifications
			}
			
			if let labPrevious = self.labAssociatedBlock {
				let previousAnalyst = labPrevious.analyst
				return previousAnalyst.shouldShowAfterClassNotifications
			}
			
			return true
		}
		
		
	}
	
}
