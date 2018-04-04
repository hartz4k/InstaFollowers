//
//  LoginVC.swift
//  InstaFollowers
//
//  Created by Mac on 17/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class LoginVC: PSViewController,UIWebViewDelegate {

    
    //MARK:- IBOutlet Define
    //MARK:-
    @IBOutlet var viewForLogin: UIView!
    @IBOutlet var loginWebView: UIWebView!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doIntialization()
        
    }
    
    //MARK: - Setup Methods
    //MARK:-

    func doIntialization() {
        viewForLogin.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.view.addSubview(viewForLogin)
        viewForLogin.isHidden = true
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
        let user_id = authToken.split(separator: ".")[0]
        defaults.set(user_id, forKey: "user_id")
        print("User ID ==", user_id)
        var dict = [String:AnyObject]()
        dict["userId"] = Int(user_id) as AnyObject
        dict["accessToken"] = authToken as AnyObject
        dict["active"] = 1 as AnyObject
        
        
        getUserDetails(access_token: authToken)
    }
    
    //MARK:- Webservice Methods
    //MARK:-
    
    //MARK: Get User Details
    func getUserDetails(access_token:String) {
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
    
    @IBAction func btnLoginAction(_ sender: Any) {
        viewForLogin.isHidden = false
        loginWebView.delegate = self
        unSignedRequest()
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        viewForLogin.isHidden = true
    }

}
