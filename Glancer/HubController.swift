//
//  HubController.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Hero

class HubController: UIViewController {
	
	@IBOutlet weak var backgroundImage: UIImageView!
	@IBOutlet weak var imageView: UIImageView!
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.imageView.hero.modifiers = [HeroModifier.opacity(0.0), HeroModifier.duration(0.8), HeroModifier.scale(0.001)]
		self.backgroundImage.hero.modifiers = [HeroModifier.duration(1.1), HeroModifier.opacity(0.0)]
		
		Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) {
			timer in
			self.openTabController()
		}
	}
	
	func openTabController() {
		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Tab") as? TabController else {
			return
		}
		
		self.present(controller, animated: true, completion: nil)
	}
	
}
