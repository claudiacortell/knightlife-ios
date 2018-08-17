//
//  BlockPrefsModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

class BlockPrefsModule: TableModule {
	
	let controller: UIViewController
	
	init(controller: UIViewController) {
		self.controller = controller
		
		super.init()
	}
	
	override func build() {
		let section = self.addSection()
		
		section.addDivider()
		section.addCell(TitleCell(title: "Block Configuration"))
		section.addDivider()

		section.addCell(BlocksPrefCell(module: self, meta: BlockMetaManager.instance.getBlockMeta(metaId: .free)))
		section.addDivider()
		section.addCell(BlocksPrefCell(module: self, meta: BlockMetaManager.instance.getBlockMeta(metaId: .x)))
		section.addDivider()
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35 / 2)
		
		section.addDivider()
		section.addCell(BlocksPrefCell(module: self, meta: BlockMetaManager.instance.getBlockMeta(metaId: .lunch)))
		section.addDivider()

		section.addCell(BlocksPrefCell(module: self, meta: BlockMetaManager.instance.getBlockMeta(metaId: .activities)))
		section.addDivider()
		
		section.addCell(BlocksPrefCell(module: self, meta: BlockMetaManager.instance.getBlockMeta(metaId: .advisory)))
		section.addDivider()
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35 / 2)
		
		section.addDivider()
		section.addCell(BlocksPrefCell(module: self, meta: BlockMetaManager.instance.getBlockMeta(metaId: .classMeeting)))
		section.addDivider()
		
		section.addCell(BlocksPrefCell(module: self, meta: BlockMetaManager.instance.getBlockMeta(metaId: .assembly)))
		section.addDivider()
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	func selected(meta: BlockMeta) {
		guard let controller = self.controller.storyboard?.instantiateViewController(withIdentifier: "SettingsBlock") as? SettingsBlockController else {
			return
		}
		
		controller.meta = meta
		self.controller.navigationController?.pushViewController(controller, animated: true)
	}
	
}
