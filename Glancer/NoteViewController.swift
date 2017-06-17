//
//  NoteViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 8/26/16.
//  Copyright © 2016 Vishnu Murale. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classNote: UITextView!
    @IBOutlet weak var noteHeader: UIView!
    @IBOutlet weak var noteTextField: UITextView!
    
    var classNameStr: String = ""
    var classNoteStr: String = ""
    var classColor: UIColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
    var selectedBlockIndex: Int = 0
    var returnSegueIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        className.text = classNameStr + " Notes"
        classNote.text = classNoteStr
        noteHeader.backgroundColor = classColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func keyboardShown(_ notification: Notification) {
        let info  = (notification as NSNotification).userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let rawFrame = value.cgRectValue
        let keyboardFrame = view.convert(rawFrame!, from: nil)
        let newFrame = CGRect(x: noteTextField.frame.origin.x, y: noteTextField.frame.origin.y, width: noteTextField.frame.width, height: noteTextField.superview!.frame.height - keyboardFrame.height - 14)
        noteTextField.frame = newFrame
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveNote" {
            let defaults = UserDefaults.standard
            var allNotes = defaults.object(forKey: "NoteTexts") as! Array<String>
            allNotes[selectedBlockIndex] = classNote.text
            defaults.set(allNotes, forKey: "NoteTexts")
           
        }
        
        let tabBar: UITabBarController = segue.destination as! UITabBarController
        tabBar.selectedIndex = returnSegueIndex
    }
}
