//
//  PaymentVC.swift
//  InstaFollowers
//
//  Created by Mac on 16/04/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Stripe

class PaymentVC: PSViewController {
    
    //MARK:-
    //MARK: Define IBOutlet
    @IBOutlet var txtCardNumber : UITextField!
    @IBOutlet var txtCardExpireMonth : UITextField!
    @IBOutlet var txtCardExpireYear : UITextField!
    @IBOutlet var txtCardCVV : UITextField!
    @IBOutlet weak var headerImagesLikeHeightConstraint: NSLayoutConstraint!
    
    //MARK:-
    //MARK: Define Variable
    var strMediaType: String!
    var strMediaLink: String = ""
    var strPlanName: String!
    var strAmount: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doIntialization()
    }
    
    func doIntialization() {
        
        if IS_IPHONE_X{
            headerImagesLikeHeightConstraint.constant = 84
        }else{
            headerImagesLikeHeightConstraint.constant = 64
        }
    }
    
    //MARK:-
    //MARK: Action Method
    @IBAction func btnConfirmAction(_ sender:UIButton) {
        let cardParams = STPCardParams()
        cardParams.number = txtCardNumber.text!
        cardParams.expMonth = UInt(txtCardExpireMonth.text!)!
        cardParams.expYear = UInt(txtCardExpireYear.text!)!
        cardParams.cvc = txtCardCVV.text!
        self.showProgressHUD()
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                self.hideProgressHUD()
                self.showAlertWithMessage(message: (error?.localizedDescription)!)
                return
            }
            let param : [String:Any] = [
                "instagram_id":String(describing: defaults.object(forKey: "user_id")!),
                "amount":self.strAmount,
                "plan_name":self.strPlanName,
                "stripe_token":"tok_visa",//token.tokenId,
                "media_type":self.strMediaType,
                "media_link":self.strMediaLink
            ]
            
            
            guard PSUtil.reachable() else
            {
                self.hideProgressHUD()
                self.showAlertWithMessage(message: PSText.Key.NoIneternet)
                return
            }
            PSWebServiceAPI.StoreTransactionAPI(param, completion: { (response) in
                self.hideProgressHUD()
                if response["Error"] == nil {
                    if response["success"]!.boolValue {
                        
                        let alert = UIAlertController(title: PSAPI.RKey.AppName, message: "Order added successfully.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                self.navigationController?.popViewController(animated: true)
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }else{
                        self.showAlertWithMessage(message: response["message"]! as! String)
                    }
                }else{
                    self.showAlertWithMessage(message: response["Error"]! as! String)
                }
            })
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Hide Status Bar
    //MARK:-
    override var prefersStatusBarHidden: Bool{
        return true
    }

}
