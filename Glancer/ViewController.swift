//
//  ViewController.swift
//  Glancer
//
//  Created by Vishnu Murale on 5/13/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Since you will do this programtically the following can go.
    @IBOutlet weak var Blue: UIView!
    @IBOutlet weak var M: UISwitch!
    @IBOutlet weak var T: UISwitch!
    @IBOutlet weak var W: UISwitch!
    @IBOutlet weak var Th: UISwitch!
    @IBOutlet weak var F: UISwitch!
    
    
    @IBOutlet weak var blockViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var blockViewBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var Gblock: UITextField!
    @IBOutlet var Fblock: UITextField!
    @IBOutlet var Eblock: UITextField!
    @IBOutlet var Dblock: UITextField!
    @IBOutlet var Ablock: UITextField!
    @IBOutlet var Bblock: UITextField!
    @IBOutlet var Cblock: UITextField!
    
    @IBOutlet weak var AColorButton: UIButton!
    
    @IBOutlet weak var BColorButton: UIButton!
    
    @IBOutlet weak var CColorButton: UIButton!
    
    @IBOutlet weak var DColorButton: UIButton!
    
    @IBOutlet weak var EColorButton: UIButton!
    
    @IBOutlet weak var FColorButton: UIButton!
    
    @IBOutlet weak var GColorButton: UIButton!
    
    var ArrayOfField = [UITextField]()
    var ArrayOfSwitch = [UISwitch]()
    var ArrayOfButton = [UIButton]()
    var ArrayOfBool = [Bool]()
    var ArrayOfText = [String]()
    var ArrayOfColor = [String]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var timer = Timer();
    
    var NeedToSave = false;
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tabBarController?.tabBar.items![0].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        self.tabBarController?.tabBar.items![1].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        self.tabBarController?.tabBar.items![2].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        //Make sure to add all the Ui element's values (string) to "ArrayOfText"
        ArrayOfText.append(Ablock.text!)
        ArrayOfText.append(Bblock.text!)
        ArrayOfText.append(Cblock.text!)
        ArrayOfText.append(Dblock.text!)
        ArrayOfText.append(Eblock.text!)
        ArrayOfText.append(Fblock.text!)
        ArrayOfText.append(Gblock.text!)
        
        //this actauly holds the UI elements, you will make these prgramtically but add the "UITextField" to "ArrayOfField"
        ArrayOfField.append(Ablock)
        ArrayOfField.append(Bblock)
        ArrayOfField.append(Cblock)
        ArrayOfField.append(Dblock)
        ArrayOfField.append(Eblock)
        ArrayOfField.append(Fblock)
        ArrayOfField.append(Gblock)
        
        //Make sure to add all the Ui element's values (bool) to "ArrayOfBool"
        ArrayOfBool.append(M.isOn)
        ArrayOfBool.append(T.isOn)
        ArrayOfBool.append(W.isOn)
        ArrayOfBool.append(Th.isOn)
        ArrayOfBool.append(F.isOn)
        
        //this holds the UI elemnts, the switches for first lunch, you will make these prgramtically but add "UISwitch" to "ArrayOfField"
        ArrayOfSwitch.append(M)
        ArrayOfSwitch.append(T)
        ArrayOfSwitch.append(W)
        ArrayOfSwitch.append(Th)
        ArrayOfSwitch.append(F)
        
        ArrayOfColor.append(getHexFromUIColor(AColorButton.backgroundColor!) + "-A")
        ArrayOfColor.append(getHexFromUIColor(BColorButton.backgroundColor!) + "-B")
        ArrayOfColor.append(getHexFromUIColor(CColorButton.backgroundColor!) + "-C")
        ArrayOfColor.append(getHexFromUIColor(DColorButton.backgroundColor!) + "-D")
        ArrayOfColor.append(getHexFromUIColor(EColorButton.backgroundColor!) + "-E")
        ArrayOfColor.append(getHexFromUIColor(FColorButton.backgroundColor!) + "-F")
        ArrayOfColor.append(getHexFromUIColor(GColorButton.backgroundColor!) + "-G")
        ArrayOfColor.append(getHexFromUIColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)) + "-X")
        
        ArrayOfButton.append(AColorButton)
        ArrayOfButton.append(BColorButton)
        ArrayOfButton.append(CColorButton)
        ArrayOfButton.append(DColorButton)
        ArrayOfButton.append(EColorButton)
        ArrayOfButton.append(FColorButton)
        ArrayOfButton.append(GColorButton)
        ArrayOfButton.append(UIButton())
        
        self.Gblock.delegate = self;
        self.Fblock.delegate = self;
        self.Eblock.delegate = self;
        self.Dblock.delegate = self;
        self.Ablock.delegate = self;
        self.Bblock.delegate = self;
        self.Cblock.delegate = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        let defaults = UserDefaults.standard
        
        if(defaults.object(forKey: "ButtonTexts") == nil){
            defaults.set(ArrayOfText, forKey: "ButtonTexts")
        }
        else {
            let UserArray: [String] = defaults.object(forKey: "ButtonTexts") as! Array<String>
            
            for index in 0...UserArray.count-1{
                ArrayOfField[index].text = UserArray[index]
            }
        }
        
        if(defaults.object(forKey: "SwitchValues") == nil){
            defaults.set(ArrayOfBool, forKey: "SwitchValues")
        }
        else {
            let UserSwitch: [Bool] = defaults.object(forKey: "SwitchValues") as! Array<Bool>
            
            for index in 0...UserSwitch.count-1{
                ArrayOfSwitch[index].isOn = UserSwitch[index]
            }
        }
        
        if(defaults.object(forKey: "ColorIDs") == nil){
            for index in 0...ArrayOfColor.count-1{
                let RGBvalues = getRGBValues(ArrayOfColor[index])
                ArrayOfButton[index].backgroundColor = UIColor(red: (RGBvalues[0] / 255.0), green: (RGBvalues[1] / 255.0), blue: (RGBvalues[2] / 255.0), alpha: 1)
            }
            
            defaults.set(ArrayOfColor, forKey: "ColorIDs")
        } else {
            let UserColor: [String] = defaults.object(forKey: "ColorIDs") as! Array<String>
            
            for index in 0...UserColor.count - 1 {
                let RGBvalues = getRGBValues(UserColor[index])
                ArrayOfButton[index].backgroundColor = UIColor(red: (RGBvalues[0] / 255.0), green: (RGBvalues[1] / 255.0), blue: (RGBvalues[2] / 255.0), alpha: 1)
                ArrayOfColor[index] = UserColor[index]
            }
            
            defaults.set(ArrayOfColor, forKey: "ColorIDs")
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
    
    func getHexFromUIColor(_ color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components![0]
        let g: CGFloat = components![1]
        let b: CGFloat = components![2]
        
        let hexString: NSString = NSString(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        
        return hexString as String
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(Dblock) {
            self.setViewMovedUp(true)
        } else if textField.isEqual(Eblock) {
            self.setViewMovedUp(true)
        } else if textField.isEqual(Fblock) {
            self.setViewMovedUp(true)
        } else if textField.isEqual(Gblock) {
            self.setViewMovedUp(true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(Ablock) {
            NeedToSave = true;
        } else if textField.isEqual(Bblock) {
            NeedToSave = true;
        } else if textField.isEqual(Cblock) {
            NeedToSave = true;
            saveInfo()
        } else if textField.isEqual(Dblock) {
            NeedToSave = true;
            self.setViewMovedUp(false)
        } else if textField.isEqual(Eblock) {
            NeedToSave = true;
            self.setViewMovedUp(false)
        } else if textField.isEqual(Fblock) {
            NeedToSave = true;
            self.setViewMovedUp(false)
        } else if textField.isEqual(Gblock) {
            NeedToSave = true;
            self.setViewMovedUp(false)
        }
    }
    
    func setViewMovedUp(_ movedUp: Bool) {
        
        if (movedUp) {
            self.blockViewTopConstraint.constant = -216
            self.blockViewBottomConstraint.constant = 216
        } else {
            self.blockViewTopConstraint.constant = 0
            self.blockViewBottomConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) 
        
    }
    
    @IBAction func MSwitched(_ sender: AnyObject) {
         NeedToSave = true;
    }
    
    @IBAction func TSwitched(_ sender: AnyObject) {
         NeedToSave = true;
    }
    
    @IBAction func WSwitched(_ sender: AnyObject) {
         NeedToSave = true;
    }
    
    @IBAction func ThSwitched(_ sender: AnyObject) {
         NeedToSave = true;
    }
    
    @IBAction func FSwitched(_ sender: AnyObject) {
         NeedToSave = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if(NeedToSave){
            saveInfo()
            appDelegate.transitionFROMsettingtoHome = true;
            appDelegate.transitionFROMsettingtoWeek = true;
            NeedToSave = false;
            appDelegate.Setting_Updated = false; 
        }
        
        
    }
    
    
    
    func saveInfo(){
        
        //let defaults = UserDefaults.standard
        let defaults = UserDefaults.standard
        
        ArrayOfText.removeAll()
        ArrayOfBool.removeAll()
        ArrayOfColor.removeAll()
        
        ArrayOfText.append(Ablock.text!)
        ArrayOfText.append(Bblock.text!)
        ArrayOfText.append(Cblock.text!)
        ArrayOfText.append(Dblock.text!)
        ArrayOfText.append(Eblock.text!)
        ArrayOfText.append(Fblock.text!)
        ArrayOfText.append(Gblock.text!)
        
        ArrayOfBool.append(M.isOn)
        ArrayOfBool.append(T.isOn)
        ArrayOfBool.append(W.isOn)
        ArrayOfBool.append(Th.isOn)
        ArrayOfBool.append(F.isOn)
        
        ArrayOfColor.append(getHexFromUIColor(AColorButton.backgroundColor!) + "-A")
        ArrayOfColor.append(getHexFromUIColor(BColorButton.backgroundColor!) + "-B")
        ArrayOfColor.append(getHexFromUIColor(CColorButton.backgroundColor!) + "-C")
        ArrayOfColor.append(getHexFromUIColor(DColorButton.backgroundColor!) + "-D")
        ArrayOfColor.append(getHexFromUIColor(EColorButton.backgroundColor!) + "-E")
        ArrayOfColor.append(getHexFromUIColor(FColorButton.backgroundColor!) + "-F")
        ArrayOfColor.append(getHexFromUIColor(GColorButton.backgroundColor!) + "-G")
        ArrayOfColor.append(getHexFromUIColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)) + "-X")
        
        defaults.set(ArrayOfText, forKey: "ButtonTexts")
        defaults.set(ArrayOfBool, forKey: "SwitchValues")
        defaults.set(ArrayOfColor, forKey: "ColorIDs")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //adds tag to end of button identifier which is being edited
        
        let defaults = UserDefaults.standard
        
        if (segue.identifier == "ColorA") {
            let temp = ArrayOfColor[0]
            ArrayOfColor[0] = temp + "-"
            defaults.set(ArrayOfColor, forKey: "ColorIDs")
        } else if (segue.identifier == "ColorB") {
            let temp = ArrayOfColor[1]
            ArrayOfColor[1] = temp + "-"
            defaults.set(ArrayOfColor, forKey: "ColorIDs")
        } else if (segue.identifier == "ColorC") {
            let temp = ArrayOfColor[2]
            ArrayOfColor[2] = temp + "-"
            defaults.set(ArrayOfColor, forKey: "ColorIDs")
        } else if (segue.identifier == "ColorD") {
            let temp = ArrayOfColor[3]
            ArrayOfColor[3] = temp + "-"
            defaults.set(ArrayOfColor, forKey: "ColorIDs")
        } else if (segue.identifier == "ColorE") {
            let temp = ArrayOfColor[4]
            ArrayOfColor[4] = temp + "-"
            defaults.set(ArrayOfColor, forKey: "ColorIDs")
        } else if (segue.identifier == "ColorF") {
            let temp = ArrayOfColor[5]
            ArrayOfColor[5] = temp + "-"
            defaults.set(ArrayOfColor, forKey: "ColorIDs")
        } else if (segue.identifier == "ColorG") {
            let temp = ArrayOfColor[6]
            ArrayOfColor[6] = temp + "-"
            defaults.set(ArrayOfColor, forKey: "ColorIDs")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
