//
//  VideoLikesVC.swift
//  InstaFollowers
//
//  Created by Mac on 18/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class VideoLikesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Variable Declaration
    //MARK:-
    var countArray : NSArray!
    var payAmountArray : NSArray!
    var videoDict = [String:AnyObject]()
    var strAmount : String = ""
    var strCount : String = ""
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var tblForVideoLikes: UITableView!
    @IBOutlet weak var headerVideoLikeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAlertForBuy: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet var lblAlertText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doIntialization()
    }
    
    func doIntialization() {
        
        if IS_IPHONE_X{
            headerVideoLikeHeightConstraint.constant = 84
        }else{
            headerVideoLikeHeightConstraint.constant = 64
        }
        
        imgUser.sd_setImage(with: URL(string: ((videoDict["images"] as! [String:AnyObject])["thumbnail"] as! [String:AnyObject])["url"] as! String), placeholderImage: #imageLiteral(resourceName: "icon-followers"))
        lblLikes.text = String(describing: "You only have \((videoDict["likes"] as! [String:AnyObject])["count"]!) viwes on this video")
        
        countArray = ["10","25","50","100","250","500","1000","2000","5000"]
        payAmountArray = ["0.49","0.99","1.49","1.99","3.99","6.99","12.99","16.99","24.99"]
        tblForVideoLikes.tableFooterView = UIView()
        tblForVideoLikes.reloadData()
        
        self.viewAlertForBuy.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(viewAlertForBuy)
        viewAlertForBuy.isHidden = true
    }
    
    //MARK:- Tableview Delegate
    //MARK:-
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tableviewCell
        cell.lblLike.text = "Get \(countArray[indexPath.row]) Views"
        cell.btnPayAmount.setTitle("$ \(payAmountArray[indexPath.row] as! String)", for: .normal)
        cell.btnPayAmount.tag = indexPath.row
        if countArray.count % 2 == 0{
            cell.backgroundColor = TABLEVIEW_CELL_BG_COLOR
        }else{
            cell.backgroundColor = .white
        }
        
        
        return cell;
    }
    
    //MARK:- Action Methods
    //MARK:-
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSettingAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBuyAction(_ sender: UIButton){
        viewAlertForBuy.isHidden = false
        strAmount = payAmountArray[sender.tag] as! String
        strCount = countArray[sender.tag] as! String
        lblAlertText.text = "Are you sure you want to buy \(strCount) Views?"
        
        
    }
    
    @IBAction func btnNOAction(_ sender: Any){
        viewAlertForBuy.isHidden = true
    }
    
    @IBAction func btnYESAction(_ sender: Any){
        viewAlertForBuy.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        vc.strAmount = strAmount
        vc.strPlanName = strCount + " Followers"
        vc.strMediaLink = videoDict["link"] as! String
        vc.strMediaType = videoDict["type"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK:- Hide Status Bar
    //MARK:-
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
