//
//  PSUtil.swift
//  ProjectStructure
//
//  Created by Nectarbits on 23/03/17.
//  Copyright © 2017 nectarbits. All rights reserved.
//

import Foundation
import UIKit

class PSUtil
{
    class func showAlertFromController(controller:UIViewController, withMessage message:String)
    {
        let alert = UIAlertController(title: PSText.Key.appName, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: PSText.Label.Ok, style: .default, handler: nil))
        
        controller.present(alert, animated: false, completion: nil)
    }
    
    class func showAlertFromController(controller:UIViewController, withMessage message:String, andHandler handler:((UIAlertAction) -> Void)?)
    {
        let alert = UIAlertController(title: PSText.Key.appName, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: PSText.Label.Ok, style: .default, handler: handler))
        
        controller.present(alert, animated: false, completion: nil)
    }
    
    class func reachable() -> Bool
    {
        let rechability = Reachability()!
        
        if rechability.isReachableViaWiFi || rechability.isReachableViaWWAN
        {
            return true
        } else {
            return false
        }
    }
}
