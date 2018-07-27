//
//  DatedNavigationBar.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/25/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DatedNavigationBar: UINavigationBar, UINavigationBarDelegate {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.delegate = self
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.delegate = self
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.setupItem(item: self.topItem)
	}
	
	override func setItems(_ items: [UINavigationItem]?, animated: Bool) {
		super.setItems(items, animated: animated)
		
		self.setupItem(item: self.topItem)
	}
	
	func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
		self.setupItem(item: item)
	}
	
	private func setupItem(item: UINavigationItem?) {
		if let dated = item as? DatedNavigationItem {
			if dated.setup {
				return
			}
			
			guard let text = dated.subtitle else {
				return
			}
			
			let titleView = UIView()
			titleView.snp.makeConstraints() {
				constrain in
				
				constrain.height.equalTo(38)
			}
			
			if dated.titleView == nil {
				dated.titleView = UIView()
			}
			
			let titleLabel = UILabel()
			titleLabel.textColor = UIColor.darkText
			titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
			titleLabel.text = dated.title
			
			let subtitleLabel = UILabel()
			subtitleLabel.textColor = UIColor.darkGray
			subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
			subtitleLabel.text = text
			
			titleView.addSubview(titleLabel)
			titleView.addSubview(subtitleLabel)
			
			titleLabel.snp.makeConstraints() {
				constrain in
				
				constrain.centerX.equalToSuperview()
				constrain.top.equalToSuperview()
			}
			
			subtitleLabel.snp.makeConstraints() {
				constrain in
				
				constrain.centerX.equalToSuperview()
				constrain.bottom.equalToSuperview().inset(2)
			}
			
			dated.titleView = titleView
			
			dated.setup = true
			dated.titleLabel = titleLabel
			dated.subtitleLabel = subtitleLabel
		}
	}
	
}

class DatedNavigationItem: UINavigationItem {
	
	var setup = false

	fileprivate var titleLabel: UILabel?
	fileprivate var subtitleLabel: UILabel?

	override var title: String? {
		didSet {
			if let label = self.titleLabel {
				label.text = self.title
			}
		}
	}
	
	@IBInspectable var subtitle: String? {
		didSet {
			if let label = self.subtitleLabel {
				label.text = self.subtitle
			}
		}
	}
	
}
