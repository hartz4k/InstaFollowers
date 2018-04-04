//
//  Constant.swift
//  InstaFollowers
//
//  Created by Mac on 15/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

let APP_NAME = "SexyBeast"

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

let defaults = UserDefaults.standard

let IS_IPHONE6_PLUS = UIScreen.main.preferredMode!.size.equalTo(CGSize(width: 1242, height: 2208))
let IS_IPHONE6 = UIScreen.main.preferredMode!.size.equalTo(CGSize(width: 750, height: 1334))
let IS_IPHONE5 = UIScreen.main.preferredMode!.size.equalTo(CGSize(width: 640, height: 1136))
let IS_IPHONE4 = UIScreen.main.preferredMode!.size.equalTo(CGSize(width: 1242, height: 960))
let IS_IPHONE_X = UIScreen.main.preferredMode!.size.equalTo(CGSize(width: 1125.0, height: 2436.0))

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let LOGIN_BUTTON_COLOR = UIColor(displayP3Red: 233.0/255.0, green: 30.0/255.0, blue: 121.0/255.0, alpha: 1)

let TABLEVIEW_CELL_BG_COLOR = UIColor(displayP3Red: 253.0/255.0, green: 232.0/255.0, blue: 241.0/255.0, alpha: 1)

struct const {
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

struct INSTAGRAM_IDS{
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    static let INSTAGRAM_CLIENT_ID = "cb09838ba5ac4079a0b0ccfa25e07212"
    static let INSTAGRAM_CLIENTSERCRET = "290a56ec676640a1a6d5d52836bd09c5"
    static let INSTAGRAM_REDIRECT_URI = "https://www.foremostdigital.com/"
    static let INSTAGRAM_ACCESS_TOKEN = "token"
    static let INSTAGRAM_SCOPE = "likes+comments+relationships" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
}

