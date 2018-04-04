//
//  SettingVC.swift
//  InstaFollowers
//
//  Created by Mac on 18/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class SettingVC: PSViewController,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Variable
    //MARK:-
    var userArray = [[String:AnyObject]]()
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var viewForLogin: UIView!
    @IBOutlet var loginWebView: UIWebView!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerSettingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblSetting : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doIntialization()
    }
    
    func doIntialization() {
        
        viewForLogin.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.view.addSubview(viewForLogin)
        viewForLogin.isHidden = true
        
        
        
        if IS_IPHONE_X{
            headerSettingHeightConstraint.constant = 84
        }else{
            headerSettingHeightConstraint.constant = 64
        }
        
        userArray = ModelManager.instance.getUserData()
        print(userArray)
        tblSetting.reloadData()
        
    }
    
    //MARK:- Tableview Delegate Methods
    //MARK:-
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! settingCell
        cell.lblUserName.text = userArray[indexPath.row]["userName"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if userArray[indexPath.row]["userId"] as! String != String(describing: defaults.object(forKey: "user_id")!){
            ModelManager.instance.updateUserData(Int(String(describing: defaults.object(forKey: "user_id")!))!)
            defaults.set(userArray[indexPath.row]["userId"], forKey: "user_id")
            defaults.set(userArray[indexPath.row]["accessToken"], forKey: "authToken")
            self.getSelectedUserDetails()
        }else{
            self.navigationController?.popViewController(animated: true)
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
        ModelManager.instance.deleteUserData()
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "user_id")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    //MARK: - unSignedRequest
    //MARK:-
    func unSignedRequest () {
        
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&display=touc&scope=%@", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        loginWebView.loadRequest(urlRequest)
    }
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        print("Instagram authentication token ==", authToken)
        viewForLogin.isHidden = true
        //Store Instagram Token In Userdefault
        defaults.set(authToken, forKey: "authToken")
        ModelManager.instance.updateUserData(Int(String(describing: defaults.object(forKey: "user_id")!))!)
        let user_id = authToken.split(separator: ".")[0]
        defaults.set(user_id, forKey: "user_id")
        getUserDetails()
    }
    
    //MARK:- Webservice Methods
    //MARK:-
    
    //MARK: Get User Details
    func getUserDetails() {
        guard PSUtil.reachable() else
        {
            self.showAlertWithMessage(message: PSText.Key.NoIneternet)
            
            return
        }
        
        PSWebServiceAPI.GetUserDetailAPI { (response) in
            print(response)
            var dict = [String:AnyObject]()
            dict["userId"] = Int(String(describing: defaults.object(forKey: "user_id")!)) as AnyObject
            dict["accessToken"] = String(describing: defaults.object(forKey: "authToken")!) as AnyObject
            dict["userName"] = response["data"]?["username"] as AnyObject
            dict["active"] = 1 as AnyObject
            
            let inserted = ModelManager.instance.Insert_UserDetail(dict)
            print(inserted)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            vc.userDict = response
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getSelectedUserDetails() {
        guard PSUtil.reachable() else
        {
            self.showAlertWithMessage(message: PSText.Key.NoIneternet)
            
            return
        }
        
        PSWebServiceAPI.GetUserDetailAPI { (response) in
            print(response)
            ModelManager.instance.updateActiveUser(Int(String(describing: defaults.object(forKey: "user_id")!))!)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            vc.userDict = response
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK:- UIWebViewDelegate Methods
    //MARK:-
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = false
        loginIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = true
        loginIndicator.stopAnimating()
        //        viewForLogin.isHidden = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    
    //MARK:- Action Methods
    //MARK:-
    
    @IBAction func btnAddAccount(_ sender: Any) {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        viewForLogin.isHidden = false
        loginWebView.delegate = self
        unSignedRequest()
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        viewForLogin.isHidden = true
    }
    
    //MARK:- Hide Status Bar
    //MARK:-
    override var prefersStatusBarHidden: Bool{
        return true
    }

}

class settingCell: UITableViewCell {
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblUserName: UILabel!
}
