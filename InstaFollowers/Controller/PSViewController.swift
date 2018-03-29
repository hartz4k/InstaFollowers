//
//  DAViewController.swift
//  DriveAbout
//
//  Created by Kevin Mac on 20/12/16.
//  Copyright © 2016 KevinMac. All rights reserved.
//

import UIKit
import SVProgressHUD

class PSViewController: UIViewController
{
    //MARK: - UIViewController Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: - SVProgressHUD Methods
    func showProgressHUD()
    {
        SVProgressHUD.show()
    }
    
    func hideProgressHUD()
    {
        SVProgressHUD.dismiss()
    }
    
    //MARK: - Alert Methods
    func showAlertWithMessage(message:String, completion: (() -> Void)?)
    {
        let alertController = UIAlertController(title: PSText.Key.appName, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: PSText.Label.Ok, style: .default)
        { (action) in
            completion?()
        }
        
       alertController.addAction(OKAction)
        
       self.present(alertController, animated: false, completion: nil)
    }
    
    func showAlertWithMessage(message:String)
    {
        self.showAlertWithMessage(message: message, completion: nil)
    }
}
