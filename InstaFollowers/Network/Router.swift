//
//  Router.swift
//  ProjectStructure
//
//  Created by Nectarbits on 23/03/17.
//  Copyright © 2017 nectarbits. All rights reserved.
//

import UIKit
import Alamofire
//https://graph.facebook.com/v3.2/search?access_token=EAAeGd4F6lFUBABB19LCDlGLsEjVjCRCeZAYXVPzJaeQbp2QUPlDQVP2DJrkfbCK7SCcCBhp08wYy2svnamhpsn17U0O5XWmdhA34MBLcLjz1A4TWb4L7e1FDvpZAdSw99efDbhXw4TdgY3ZBQ26HrP4MjcPeylOWemQXIj6RlTBeQvzPxdt3iTl5QO7oRC5LNZBWttbxZAUpRWPj4kYuE5pnfTpw8BLgaM3vZBP0NQ2gZDZD&type=place&center=23.025790,72.587270&distance=50&limit=25
let BasePath = "http://foremostdigitalcloud.ca:4000/"

let BaseUserRegister = BasePath + "user/register"
let BaseStoreTransaction = BasePath + "payment/storeTransaction"
let BaseShowTransaction = BasePath + "payment/showTransactions"
let InstagramUserPath = INSTAGRAM_IDS.INSTAGRAM_APIURl

protocol Routable
{
    var path        : String {get}
    var method      : HTTPMethod {get}
    var parameters  : Parameters? {get}
    var keys        : String? {get}
}

enum Router: Routable, CustomDebugStringConvertible
{
    
    case GetUserDetail()
    case GetUserPhotos()
    case UserRegister(Parameters)
    case storeTransaction(Parameters)
    case showTransactions(Parameters)
    

    var debugDescription: String
    {
        var printString = ""
        
        printString     += "\n*********************************"
        printString     += "\nMethod : \(method)"
        printString     += "\nParameter : \(String(describing: parameters))"
        printString     += "\nPath : \(path)"
        printString     += "\n*********************************\n"
        printString     += "\nKeys : \(String(describing: keys))"
        printString     += "\n*********************************\n"
        
        return printString
    }
}

extension Router
{
    var keys: String?
    {
        switch self
        {
            case .GetUserDetail:
                return nil
            
            case .GetUserPhotos:
                return nil
            
            case .UserRegister:
                    return nil
            
            case .storeTransaction:
                return nil
            
            case .showTransactions:
                return nil
        }
    }
}

extension Router
{
    var path: String
    {
        switch self
        {
            case .GetUserDetail:
                return "\(InstagramUserPath)\(String(describing: defaults.object(forKey: "user_id")!))/?access_token=\(String(describing: defaults.object(forKey: "authToken")!))"
            
            case .GetUserPhotos:
                return "\(InstagramUserPath)\(String(describing: defaults.object(forKey: "user_id")!))/media/recent?access_token=\(String(describing: defaults.object(forKey: "authToken")!))"
            
            case .UserRegister:
                return BaseUserRegister
            
            case .storeTransaction:
                return BaseStoreTransaction
            
            case .showTransactions:
                return BaseShowTransaction
        }
    }
}

extension Router
{
    var method: HTTPMethod
    {
        switch self
        {
            case .GetUserDetail:
                return .get
            
            case .GetUserPhotos:
                return .get
            
            case .UserRegister:
                return .post
            
            case .storeTransaction:
                return .post
            
            case .showTransactions:
                return .post
        }
    }
}

extension Router
{
    var parameters: Parameters?
    {
        switch self
        {
            case .GetUserDetail:
                return nil
            
            case .GetUserPhotos:
                return nil
            
            case .UserRegister(let param):
                return param
            
            case .storeTransaction(let param):
                return param
            
            case .showTransactions(let param):
                return param
        }
    }
}

