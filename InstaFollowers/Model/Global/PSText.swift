//
//  PSText.swift
//  ProjectStructure
//
//  Created by Nectarbits on 23/03/17.
//  Copyright © 2017 nectarbits. All rights reserved.
//

import Foundation


struct PSAPI
{
    struct RCode
    {
        static let Success      = "Success"
        static let UnSuccess    = "Unsuccess"
    }
    
    struct RKey
    {
        static let Code    = "status"
        static let Message = "message"
        static let Data    = "data"
        static let AppName = "InstaFollowers"
    }
    
    static let accessToken  = "Authorization"
}



struct PSText
{
    struct Label
    {
        static let Ok          = "OK"
        static let Done        = "Done"
        static let Cancel      = "Cancel"
        static let fromCamera  = "Take Photo"
        static let fromLibrary = "From Albums"
    }
    
    struct Key
    {
        static let appName     = "BidLocal"
        static let appLanguage = "applanguage"
        static let appMessages = "appmessages"
        static let NoIneternet = "Please check Internet..!"
    }
}
