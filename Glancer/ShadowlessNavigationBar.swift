//
//  ShadowlessNavigationBar.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/21/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Presentr
import Hero

class NavigationBarController: UINavigationController, UINavigationControllerDelegate
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationBar.shadowImage = UIImage()
		
		self.isHeroEnabled = true
		
		self.interactivePopGestureRecognizer?.delegate = nil		
	}
}

//class HeroHelper: NSObject {
//
//	func configureHero(in navigationController: UINavigationController) {
//		guard let topViewController = navigationController.topViewController else { return }
//
//		topViewController.isHeroEnabled = true
//		navigationController.isHeroEnabled = true
//		navigationController.delegate = self
//	}
//}
//
////Navigation Popping
//private extension HeroHelper {
//	private func addEdgePanGesture(to view: UIView) {
//		let pan = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(popViewController(_:)))
//		pan.edges = .left
//		view.addGestureRecognizer(pan)
//	}
//
//	@objc private func popViewController(_ gesture: UIScreenEdgePanGestureRecognizer) {
//		guard let view = gesture.view else { return }
//		let translation = gesture.translation(in: nil)
//		let progress = translation.x / 2 / view.bounds.width
//
//		switch gesture.state {
//		case .began:
//			print("test")
////			UIViewController.con.firhero_dismissViewController()
//		case .changed:
//			Hero.shared.update(progress)
//		default:
//			if progress + gesture.velocity(in: nil).x / view.bounds.width > 0.3 {
//				Hero.shared.finish()
//			} else {
//				Hero.shared.cancel()
//			}
//		}
//	}
//}
//
//
////Navigation Controller Delegate
//extension HeroHelper: UINavigationControllerDelegate {
//
//	func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//		return Hero.shared.navigationController(navigationController, interactionControllerFor: animationController)
//	}
//
//	func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//		if operation == .push {
//			addEdgePanGesture(to: toVC.view)
//		}
//		return Hero.shared.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
//	}
//}

