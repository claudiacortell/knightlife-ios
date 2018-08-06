//
//  CalendarView.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/5/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

class CalendarView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
	
	override func reloadData() {
		self.delegate = self
		self.dataSource = self
		
		super.reloadData()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 7
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return self.dequeueReusableCell(withReuseIdentifier: "date", for: indexPath)
	}

}
