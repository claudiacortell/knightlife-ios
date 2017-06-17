//
//  BlockTableViewCell.swift
//  Glancer
//
//  Created by Cassandra Kane on 11/29/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class BlockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var blockLetter: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classTimes: UILabel!
    
    var label: Label? {
        didSet {
            if let label = label {
                //sets up note table cell
                self.blockLetter.text = label.blockLetter
                self.className.text = label.className
                self.classTimes.text = label.classTimes
                let RGBvalues = getRGBValues(label.color)
                self.backgroundColor = UIColor(red: (RGBvalues[0] / 255.0), green: (RGBvalues[1] / 255.0), blue: (RGBvalues[2] / 255.0), alpha: 1)
            }
        }
    }
    
    func getRGBValues(_ hex: String) -> [CGFloat] {
        //Hex Format: XXXXXX- (only has a tag at the end if it's the one being edited, tag should be deleted within color selection class)
        
        let cString:String = hex.trimmingCharacters(in: .whitespaces).uppercased()

        let rString = cString.substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
        let gString = cString.substring(from: hex.characters.index(hex.startIndex, offsetBy: 2)).substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
        let bString = cString.substring(from: hex.characters.index(hex.startIndex, offsetBy: 4)).substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
        
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        let redFloat: CGFloat = CGFloat(r)
        let greenFloat: CGFloat = CGFloat(g)
        let blueFloat:CGFloat = CGFloat(b)
        
        var values: [CGFloat] = [CGFloat]()
        
        values.append(redFloat)
        values.append(greenFloat)
        values.append(blueFloat)
        return values
    }
    
    
}
