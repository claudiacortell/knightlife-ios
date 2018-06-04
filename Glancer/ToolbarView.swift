//
//  ToolbarView.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import UIKit

class ToolbarView: UIView {

	@IBOutlet private var contentView: UIView!
	
	private let minTrayHeight: CGFloat = 44.0
	
	@IBOutlet weak private var resizableTrayView: UIView!
	@IBOutlet weak private var todayLabel: UILabel!
	@IBOutlet weak private var subtitleLabel: UILabel!
	
	@IBOutlet weak private var subtitleContainerView: UIView!
	
	@IBOutlet weak private var paginationView: UIView!
	@IBOutlet weak private var paginationStack: UIStackView!

	private var paginationSelectedFont: UIFont!
	private var paginationSelectedColor: UIColor!
	private var paginationUnselectedFont: UIFont!
	private var paginationUnselectedColor: UIColor!

	@IBOutlet weak private var resizableTrayConstraint: NSLayoutConstraint!
	@IBOutlet weak private var subtitleContainerConstraint: NSLayoutConstraint!
	@IBOutlet weak private var paginationConstraint: NSLayoutConstraint!

	private var defaultTrayHeight: CGFloat = 0.0
	private var defaultSubtitleHeight: CGFloat = 0.0
	private var defaultPaginationHeight: CGFloat = 0.0

	private var trayHeight: CGFloat { return self.resizableTrayView.frame.height }
	private var subtitleHeight: CGFloat { return self.subtitleContainerView.frame.height }
	private var paginationHeight: CGFloat { return self.paginationView.frame.height }
	
	private var scrollPercentage: CGFloat { return (max(0, self.trayHeight) - self.minTrayHeight) / max(1, self.defaultTrayHeight - self.minTrayHeight) }
	
	var originalHeight: CGFloat { return self.defaultTrayHeight + self.defaultPaginationHeight }
	var heightChangedCallback: [(CGFloat) -> Void] = []
	
	var title: String? = nil {
		didSet {
			self.todayLabel.text = self.title
			self.trayValuesChanged()
		}
	}
	
	var subtitle: String? = nil {
		didSet {
			self.subtitleLabel.text = self.subtitle
			self.trayValuesChanged()
		}
	}
	
	var pagination: [String] = [] {
		didSet {
			self.reloadPagination()
		}
	}
	
	var paginationSelected: Int = 0 {
		didSet {
			self.reloadPagination()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.doInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.doInit()
	}
	
	private func doInit() {
		Bundle.main.loadNibNamed("ToolbarView", owner: self, options: nil)
		self.addSubview(self.contentView)
		self.contentView.frame = self.bounds
		self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
	}
	
	func viewDidLoad() {
		self.paginationSelectedFont = (self.paginationStack.subviews[0] as! UILabel).font
		self.paginationSelectedColor = (self.paginationStack.subviews[0] as! UILabel).textColor

		self.paginationUnselectedFont = (self.paginationStack.subviews[1] as! UILabel).font
		self.paginationUnselectedColor = (self.paginationStack.subviews[1] as! UILabel).textColor

		self.updateOurViewConstraints()
		
		self.defaultTrayHeight = self.trayHeight
		self.defaultSubtitleHeight = self.subtitleHeight
		self.defaultPaginationHeight = self.paginationHeight
		
		self.resetValues()
	}
	
	func resetValues() {
		self.title = ""
		self.subtitle = nil
		self.pagination = []
	}
	
	func didScroll(_ amount: CGFloat) {
		self.resizableTrayConstraint.constant = max(0, self.defaultTrayHeight - amount)
		self.subtitleContainerConstraint.constant = self.defaultSubtitleHeight * self.scrollPercentage
		
		self.subtitleLabel.layer.opacity = Float(self.scrollPercentage)

		self.todayLabel.font = UIFont.systemFont(ofSize: 18.0 + (4 * self.scrollPercentage), weight: .semibold)
		
		self.updateOurViewConstraints()
	}
	
	private func updateOurViewConstraints() {
		self.resizableTrayView.setNeedsUpdateConstraints()
		self.resizableTrayView.updateConstraintsIfNeeded()
		
		self.subtitleContainerView.setNeedsUpdateConstraints()
		self.subtitleContainerView.updateConstraintsIfNeeded()
		
		self.paginationView.setNeedsUpdateConstraints()
		self.paginationView.updateConstraintsIfNeeded()
	}
	
	private func trayValuesChanged() {
		self.resizableTrayConstraint.constant = 10000.0
		self.subtitleContainerConstraint.constant = 10000.0

		if self.subtitle == nil || self.subtitle! == "" {
			self.subtitleContainerView.isHidden = true
			self.defaultSubtitleHeight = 0.0
			self.subtitleContainerConstraint.constant = 0.0
		} else {
			self.subtitleContainerView.isHidden = false
			self.defaultSubtitleHeight = self.subtitleHeight
			self.subtitleContainerConstraint.constant = self.defaultSubtitleHeight
		}
		
		self.defaultTrayHeight = self.trayHeight
		self.resizableTrayConstraint.constant = self.defaultTrayHeight
		
		self.updateOurViewConstraints()
		
		for callback in self.heightChangedCallback {
			callback(self.originalHeight)
		}
	}
	
	private func reloadPagination() {
		for view in self.paginationStack.subviews {
			view.removeFromSuperview()
		}

		if self.pagination.isEmpty {
			self.paginationConstraint.constant = 0.0
		} else {
			self.paginationConstraint.constant = self.defaultPaginationHeight
		}

		for i in 0..<self.pagination.count {
			let newLabel = UILabel()

			newLabel.text = self.pagination[i]
			newLabel.font = i == self.paginationSelected ? self.paginationSelectedFont : self.paginationUnselectedFont
			newLabel.textColor = i == self.paginationSelected ? self.paginationSelectedColor : self.paginationUnselectedColor

			self.paginationStack.addArrangedSubview(newLabel)
		}
		
		self.updateOurViewConstraints()
		
		for callback in self.heightChangedCallback {
			callback(self.originalHeight)
		}
	}
	
	func addHeightChangedCallback(_ callback: @escaping (CGFloat) -> Void) {
		self.heightChangedCallback.append(callback)
	}
}
