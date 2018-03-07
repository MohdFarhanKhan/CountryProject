//
//  Extension.swift
//  CountryProject
//
//  Created by Mohd Farhan Khan on 3/7/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//

import UIKit
extension Dictionary where Key: ExpressibleByStringLiteral{
    func valueFor(key:String)->AnyObject?{
        let selfDict = self as! [String : AnyObject]
        let correctKey = key.giveExactKey(dict: selfDict)
        return selfDict[correctKey]!
        
    }
}
extension String{
    func giveExactKey(dict: [ String: AnyObject])->String{
        let keyArray = dict.keys
        var correctKey = " "
        for key in keyArray{
            
            if key.localizedCaseInsensitiveContains(self){
                correctKey = self
                break
            }
        }
        
        return correctKey
    }
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}

@IBDesignable class DesignableImageView: UIImageView { }
@IBDesignable class DesignableButton:UIButton { }

extension UIView {
    @IBInspectable
    var borderWidth :CGFloat {
        get {
            return layer.borderWidth
        }
        
        set(newBorderWidth){
            layer.borderWidth = newBorderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get{
            
            return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) :nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius :CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }
    
    //  @IBInspectable
    var makeCircular:Bool {
        get{
            return true
        }
        
        set {
            
            cornerRadius = min(bounds.width, bounds.height) / 2.0
            
        }
    }
}
