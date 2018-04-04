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
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var tblForImageLikes: UITableView!
    @IBOutlet weak var headerImagesLikeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAlertForBuy: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblLikes: UILabel!
    
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
        lblLikes.text = String(describing: "You only have \((imageDict["likes"] as! [String:AnyObject])["count"]!) likes")
        
        countArray = ["10","25","50","100","250","500","1000","2000"]
        payAmountArray = ["$ 0.50","$ 0.75","$ 1.09","$ 2.99","$ 5.99","$ 9.99","15.99","$ 19.99"]
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
        cell.btnPayAmount.setTitle(payAmountArray[indexPath.row] as? String, for: .normal)
        
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
    
    @IBAction func btnBuyAction(_ sender: Any){
        viewAlertForBuy.isHidden = false
    }
    
    @IBAction func btnNOAction(_ sender: Any){
        viewAlertForBuy.isHidden = true
    }
}
