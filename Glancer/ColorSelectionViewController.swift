//
//  ColorSelectionViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 6/11/16.
//  Copyright © 2016 Vishnu Murale. All rights reserved.
//

import UIKit

class ColorSelectionViewController: UIViewController {
    
    var ArrayOfColor: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        self.ArrayOfColor = defaults.object(forKey: "ColorIDs") as! Array<String>
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("old array", ArrayOfColor)
        print()
        var newArrayOfColor: [String] = [String]()
        let blocks: [String] = ["-A", "-B", "-C", "-D", "-E", "-F", "-G", "-X"]
        var count = 0;
        
        for color in ArrayOfColor {
            var newColor: String = ""
            if (color.characters.count == 9) {
                newColor = segue.identifier! + blocks[count]
            } else {
                newColor = color
            }
            newArrayOfColor.append(newColor)
            count += 1
        }
        
        print("new array", newArrayOfColor)
        print()
        
        //let defaults = UserDefaults.standard
        let defaults = UserDefaults.standard
        defaults.set(newArrayOfColor, forKey: "ColorIDs")

        
        let tabBar: UITabBarController = segue.destination as! UITabBarController
        tabBar.selectedIndex = 2
    }
    
}
