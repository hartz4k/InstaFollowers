//
//  ViewController.swift
//  InstaFollowers
//
//  Created by Mac on 15/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class DashboardVC: PSViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- Variable Declaration
    //MARK:-
    var countArray : NSArray!
    var payAmountArray : NSArray!
    var userDict = [String:AnyObject]()
    var userPhotosArray = [[String:AnyObject]]()
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var viewForLike: UIView!
    @IBOutlet weak var viewAlertForBuy: UIView!
    @IBOutlet weak var viewForImages: UIView!
    @IBOutlet weak var headerLikeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerImagesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerVideoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewForVideo: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var collectionViewForLikes: UICollectionView!
    @IBOutlet var collectionViewForViews: UICollectionView!
    @IBOutlet var tblForFollowers: UITableView!
    @IBOutlet var imgFollowers: UIImageView!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblFollowers: UILabel!
    @IBOutlet var lblFollowing: UILabel!
    @IBOutlet var imgLikes: UIImageView!
    @IBOutlet var imgViews: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.view.layoutIfNeeded()
        self.doIntialization()
    }

    override func viewWillLayoutSubviews() {
        
        if IS_IPHONE_X{
            headerLikeHeightConstraint.constant = 84
            headerImagesHeightConstraint.constant = 84
            headerVideoHeightConstraint.constant = 84
        }else{
            headerLikeHeightConstraint.constant = 64
            headerImagesHeightConstraint.constant = 64
            headerVideoHeightConstraint.constant = 64
        }
        
        self.viewForLike.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        self.viewForImages.frame = CGRect(x: scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        self.viewForVideo.frame = CGRect(x: scrollView.frame.size.width*2, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        self.scrollView!.addSubview(self.viewForLike)
        self.scrollView!.addSubview(self.viewForImages)
        self.scrollView!.addSubview(self.viewForVideo)
        let scrollWidth: CGFloat  = 3 * self.view.frame.width
        self.scrollView!.contentSize = CGSize(width: scrollWidth, height: scrollView.frame.size.height);
        
        self.viewAlertForBuy.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(viewAlertForBuy)
        viewAlertForBuy.isHidden = true
    }
    
    func doIntialization() {
        
        countArray = ["5","20","50","100","250","500","1000"]
        payAmountArray = ["$ 0.30","$ 1.39","$ 3.99","$ 6.99","$ 9.99","$ 14.99","$ 19.99"]
        
        imgFollowers.image = #imageLiteral(resourceName: "icon-selectedFollowers")
        imgUser.sd_setImage(with: URL(string: (userDict["data"] as! [String:AnyObject])["profile_picture"] as! String), placeholderImage: #imageLiteral(resourceName: "icon-followers"))
        lblFollowers.text = String(describing: ((userDict["data"] as! [String:AnyObject])["counts"] as! [String:AnyObject])["followed_by"]!)
        lblFollowing.text = String(describing: ((userDict["data"] as! [String:AnyObject])["counts"] as! [String:AnyObject])["follows"]!)
        tblForFollowers.tableFooterView = UIView()
        tblForFollowers.reloadData()
        collectionViewForLikes.reloadData()
        collectionViewForViews.reloadData()
    }
    
    func callAPIForGetUserDetail() {
        
    }
    
    //MARK:- Collectionview Delegate
    //MARK:-
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewForLikes {
            return userPhotosArray.count
        }else{
            return 100
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewForLikes {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! instagramPhotoCell
            cell.userImg.sd_setImage(with: URL(string: ((userPhotosArray[indexPath.row]["images"] as! [String:AnyObject])["thumbnail"] as! [String:AnyObject])["url"] as! String), placeholderImage: #imageLiteral(resourceName: "icon-followers"))
            cell.lblLike.text = String(describing: (userPhotosArray[indexPath.row]["likes"] as! [String:AnyObject])["count"]!)
            return cell
        }else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! instagramVideoCell
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewForLikes {
            let yourWidth = (self.view.bounds.width-60)/3.0
            let yourHeight = yourWidth + 30
            
            return CGSize(width: yourWidth, height: yourHeight)
        }else{
            let yourWidth = (self.view.bounds.width-60)/3.0
            let yourHeight = yourWidth
            
            return CGSize(width: yourWidth, height: yourHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewForLikes {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageLikesVC") as! ImageLikesVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoLikesVC") as! VideoLikesVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Tableview Delegate
    //MARK:-
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tableviewCell
        cell.lblLike.text = "Get \(countArray[indexPath.row]) Followers"
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
    
    @IBAction func btnFollowersAction(_ sender: Any) {
        imgFollowers.image = #imageLiteral(resourceName: "icon-selectedFollowers")
        imgViews.image = #imageLiteral(resourceName: "icon-views")
        imgLikes.image = #imageLiteral(resourceName: "icon-likes")
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func btnLikesAction(_ sender: Any) {
        imgLikes.image = #imageLiteral(resourceName: "icon-selectedLikes")
        imgViews.image = #imageLiteral(resourceName: "icon-views")
        imgFollowers.image = #imageLiteral(resourceName: "icon-followers")
        self.scrollView.setContentOffset(CGPoint(x: (UIScreen.main.bounds.size.width * 1), y: 0), animated: true)
        self.getUserPhotos()
    }
    
    @IBAction func btnViewsAction(_ sender: Any) {
        imgViews.image = #imageLiteral(resourceName: "icon-selectedViews")
        imgFollowers.image = #imageLiteral(resourceName: "icon-followers")
        imgLikes.image = #imageLiteral(resourceName: "icon-likes")
        self.scrollView.setContentOffset(CGPoint(x: (UIScreen.main.bounds.size.width * 2), y: 0), animated: true)
    }
    
    @IBAction func btnBuyAction(_ sender: Any){
        viewAlertForBuy.isHidden = false
    }
    
    @IBAction func btnNOAction(_ sender: Any){
        viewAlertForBuy.isHidden = true
    }
    
    @IBAction func btnSettingAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Webservice Methods
    //MARK:-
    
    //MARK: Get User Photos
    func getUserPhotos() {
        guard PSUtil.reachable() else
        {
            self.showAlertWithMessage(message: PSText.Key.NoIneternet)
            
            return
        }
        
        PSWebServiceAPI.GetUserPhotosAPI { (response) in
            print(response)
            self.userPhotosArray = response["data"] as! [[String : AnyObject]]
            print(self.userPhotosArray)
            
            if self.userPhotosArray.count != 0 {
                self.collectionViewForLikes.reloadData()
            }
            
        }
    }
    
    //MARK:- Hide Status Bar
    //MARK:-
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}

class tableviewCell: UITableViewCell{
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var btnPayAmount : UIButton!
    @IBOutlet var lblLike : UILabel!
}

class instagramPhotoCell: UICollectionViewCell{
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var userImg : UIImageView!
    @IBOutlet var likeImg : UIImageView!
    @IBOutlet var lblLike : UILabel!
}

class instagramVideoCell: UICollectionViewCell{
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet var userImg : UIImageView!
    @IBOutlet var likeImg : UIImageView!
    @IBOutlet var lblLike : UILabel!
}
