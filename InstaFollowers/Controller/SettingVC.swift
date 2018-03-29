//
//  SettingVC.swift
//  InstaFollowers
//
//  Created by Mac on 18/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var headerSettingHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doIntialization()
    }
    
    func doIntialization() {
        
        if IS_IPHONE_X{
            headerSettingHeightConstraint.constant = 84
        }else{
            headerSettingHeightConstraint.constant = 64
        }
    }
    
    //MARK:- Action Methods
    //MARK:-
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        let cookieJar : HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! as [HTTPCookie]{
            NSLog("cookie.domain = %@", cookie.domain)
            
            if cookie.domain == "www.instagram.com" ||
                cookie.domain == "api.instagram.com"{
                
                cookieJar.deleteCookie(cookie)
            }
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    
    //MARK:- Hide Status Bar
    //MARK:-
    override var prefersStatusBarHidden: Bool{
        return true
    }

}
