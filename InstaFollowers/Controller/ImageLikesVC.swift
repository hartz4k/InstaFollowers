//
//  ImageLikesVC.swift
//  InstaFollowers
//
//  Created by Mac on 18/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ImageLikesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Variable Declaration
    //MARK:-
    var countArray : NSArray!
    var payAmountArray : NSArray!
    var imageDict = [String:AnyObject]()
    var strAmount : String = ""
    var strCount : String = ""
    
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var tblForImageLikes: UITableView!
    @IBOutlet weak var headerImagesLikeHeightConstraint: NSLayoutConstraint!
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
            headerImagesLikeHeightConstraint.constant = 84
        }else{
            headerImagesLikeHeightConstraint.constant = 64
        }
        
        imgUser.sd_setImage(with: URL(string: ((imageDict["images"] as! [String:AnyObject])["thumbnail"] as! [String:AnyObject])["url"] as! String), placeholderImage: #imageLiteral(resourceName: "icon-followers"))
        lblLikes.text = String(describing: "You only have \((imageDict["likes"] as! [String:AnyObject])["count"]!) likes on this photo")
        
        countArray = ["10","25","50","100","250","500","1000","2000","5000"]
        payAmountArray = ["0.99","1.99","2.99","4.99","9.99","12.99","16.99","20.99","29.99"]
        tblForImageLikes.tableFooterView = UIView()
        tblForImageLikes.reloadData()
        
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
        cell.lblLike.text = "Get \(countArray[indexPath.row]) Likes"
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
        lblAlertText.text = "Are you sure you want to buy \(strCount) Likes?"
    }
    
    @IBAction func btnNOAction(_ sender: Any){
        viewAlertForBuy.isHidden = true
    }
    
    @IBAction func btnYESAction(_ sender: Any){
        viewAlertForBuy.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        vc.strAmount = strAmount
        vc.strPlanName = strCount + " Followers"
        vc.strMediaLink = imageDict["link"] as! String
        vc.strMediaType = imageDict["type"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Hide Status Bar
    //MARK:-
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
