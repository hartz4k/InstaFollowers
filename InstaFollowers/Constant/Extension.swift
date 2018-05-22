//
//  Extension.swift
//  SexyBeast
//
//  Created by Intelivita IOS Senior on 28/12/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import Foundation
import UIKit
//import KVNProgress
import SwiftyJSON
import QuartzCore

private var maxLengths = [UITextField: Int]()

extension UIViewController
{
    func hideNavigation()
    {
        self.navigationController?.navigationBar.isHidden = true
    }
    func showNavigation()
    {
        self.navigationController?.navigationBar.isHidden = false
    }
    func pushSeg(segName:String)
    {
        self.performSegue(withIdentifier: segName, sender: self)
    }
    func popScreen()
    {
        self.navigationController?.popViewController(animated: true)
    }
//    func showProgress(){
//        KVNProgress.show()
//    }
//    func hideProgress(){
//        KVNProgress.dismiss()
//    }
}
extension UIButton
{
    func setShadow()
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.50
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1.0
    }
}
extension UILabel
{
    func setShadow()
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.75
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 2.0
    }
}
extension String
{
    func isNumber() -> Bool
    {
        let characterSet = CharacterSet.init(charactersIn: "+0123456789")
        
        if self.rangeOfCharacter(from: characterSet.inverted) != nil {
            return false
        }
        return true
    }
    
    func isAlphabet() -> Bool
    {
        let characterSet = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ")
        
        if self.rangeOfCharacter(from: characterSet.inverted) != nil
        {
            return false
        }
        return true
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    func getDateFromString(strDate:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //Your date format
        let date = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let datestr = dateFormatter.string(from: date!) //according to date format your date string
        return datestr
    }
}
extension UITextField
{
    func setShadow()
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.75
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 2.0
    }
    @IBInspectable var maxLength: Int
        {
        
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }
    
    @objc func limitLength(textField:UITextField){
        guard let prospectiveText = textField.text , prospectiveText.characters.count > maxLength
            
            else
        {
            return
        }
        
        let selection = selectedTextRange
        
        let index = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        
        text = prospectiveText.substring(to: index)
        
        selectedTextRange = selection
    }
    
    func isUserName() -> Bool
    {
        let RegEx = "\\A\\w{7,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self.text)
    }
    func isValidEmail() -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    func isValidName() -> Bool
    {
        let emailRegEx = "[A-Za-z]"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    public func isEmpty()->Int
    {
        if self.text! != ""
        {
            return 0
        }

        self.shake()
        return 1
    }
    public func shake()
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.10
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10,y: self.center.y))
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.add(animation, forKey: "position")
    }
    
    
}
extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}
extension UIColor{
    func clearColor(red:CGFloat,green:CGFloat,blue:CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: green/255.0, alpha: 1.0)
    }
}
extension UIView{
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    func makeRounded()
    {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    var snapshot: UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIImage {
    func maskedImage(mask: UIImage) -> UIImage {
        
        guard
            let imageReference = self.cgImage,
            let maskReference = mask.cgImage,
            let dataProvider = maskReference.dataProvider,
            
            let imageMask = CGImage(
                maskWidth: maskReference.width,
                height: maskReference.height,
                bitsPerComponent: maskReference.bitsPerComponent,
                bitsPerPixel: maskReference.bitsPerPixel,
                bytesPerRow: maskReference.bytesPerRow,
                provider: dataProvider,
                decode: nil,
                shouldInterpolate: true
            ),
            
            let maskedReference = imageReference.masking(imageMask)
            else {
                return mask
        }
        
        return UIImage(cgImage: maskedReference)//.maskWithColor(color: UIColor.red.withAlphaComponent(1.0))!
    }
}


extension Data {
    var format: String {
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
    }
}

protocol JSONable
{
    init?(parameter: JSON)
}

extension JSON
{
    func to<T>(type: T?) -> Any?
    {
        if let baseObj = type as? JSONable.Type
        {
            if self.type == .array
            {
                var arrObject: [Any] = []
                
                arrObject = self.arrayValue.map
                    {
                        baseObj.init(parameter: $0)!
                }
                return arrObject
            }
            else
            {
                let object = baseObj.init(parameter: self)
                return object!
            }
        }
        return nil
    }
}


