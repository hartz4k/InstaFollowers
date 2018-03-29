//
//  Router.swift
//  ProjectStructure
//
//  Created by Nectarbits on 23/03/17.
//  Copyright © 2017 nectarbits. All rights reserved.
//

import UIKit
import Alamofire

let BasePath = "http://iappbits.in/"

let BaseAPIPathForAuction = BasePath + "Api/auction/"
let BaseAPIPath = BasePath + "Api/Webservice/"
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
        }
    }
}

