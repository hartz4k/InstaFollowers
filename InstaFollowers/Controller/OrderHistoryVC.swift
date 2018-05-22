//
//  OrderHistoryVC.swift
//  InstaFollowers
//
//  Created by Mac on 16/04/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class OrderHistoryVC: PSViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:-
    //MARK: Define IBOutlet
    @IBOutlet var tblOrderHistory : UITableView!
    @IBOutlet weak var headerImagesLikeHeightConstraint: NSLayoutConstraint!
    
    //MARK:-
    //MARK: Define Variable
    var orderHistoryArray = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doIntialization()
    }
    
    func doIntialization ()
    {
        if IS_IPHONE_X{
            headerImagesLikeHeightConstraint.constant = 84
        }else{
            headerImagesLikeHeightConstraint.constant = 64
        }
        
        tblOrderHistory.estimatedRowHeight = 112
        tblOrderHistory.rowHeight = UITableViewAutomaticDimension
        tblOrderHistory.tableFooterView = UIView()
        
        getOrderHistory()
        
    }
    
    //MARK:-
    //MARK: Webservice Call
    
    func getOrderHistory() {
        showProgressHUD()
        guard PSUtil.reachable() else
        {
            hideProgressHUD()
            self.showAlertWithMessage(message: PSText.Key.NoIneternet)
            return
        }
        let param : [String:Any] = ["instagram_id":String(describing: defaults.object(forKey: "user_id")!)]
        PSWebServiceAPI.ShowTransactionsAPI(param) { (response) in
            self.hideProgressHUD()
            if response["Error"] == nil {
                if response["success"]!.boolValue {
                    self.orderHistoryArray = response["data"]! as! [[String : AnyObject]]
                    self.tblOrderHistory.reloadData()
                }else{
                    self.showAlertWithMessage(message: response["message"]! as! String)
                }
            }else{
                self.showAlertWithMessage(message: response["Error"]! as! String)
            }
        }
    }
    
    //MARK:-
    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! orderHistoryCell
        cell.btnAmount.setTitle("$ \(String(describing: orderHistoryArray[indexPath.row]["amount"]!))", for: .normal)
        cell.lblPlanName.text = "Plan name : \(String(describing: orderHistoryArray[indexPath.row]["plan_name"]!))"
        cell.lblTransDate.text = "Date : \(String(describing: String().getDateFromString(strDate: orderHistoryArray[indexPath.row]["created_at"] as! String)))"
        cell.lblTransID.text = "Trans. ID : \(String(describing: orderHistoryArray[indexPath.row]["transaction_id"]!))"
        return cell
    }
    
    //MARK:-
    //MARK: Action Methods
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Hide Status Bar
    //MARK:-
    override var prefersStatusBarHidden: Bool{
        return true
    }

}

class orderHistoryCell: UITableViewCell{
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var btnAmount : UIButton!
    @IBOutlet var lblPlanName : UILabel!
    @IBOutlet var lblTransDate : UILabel!
    @IBOutlet var lblTransID : UILabel!
}
