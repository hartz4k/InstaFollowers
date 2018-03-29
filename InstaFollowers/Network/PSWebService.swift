//
//  WebService.swift
//  ProjectStructure
//
//  Created by Nectarbits on 23/03/17.
//  Copyright © 2017 nectarbits. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let PSWebServiceAPI: PSWebService = PSWebService.APIClient
 
class PSWebService: SessionManager
{
    var header = ["Content-Type" : "application/x-www-form-urlencoded"]
    
    static let APIClient: PSWebService =
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 180
        configuration.timeoutIntervalForRequest  = 180
        
        return PSWebService(configuration: configuration)
    }()
    
    func set(authorizeToken token: String?)
    {
        header[PSAPI.accessToken] = "Bearer "+token!
    }
    
    func removeAuthorizeToken()
    {
        header.removeValue(forKey: PSAPI.accessToken)
    }
    
    func sendRequest(_ route: Router)
        -> DataRequest
    {
        let path = route.path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
            
        var encoding: ParameterEncoding = JSONEncoding.default
 
        var parameter = route.parameters
        
        if(route.method == .post)
        {
            encoding = URLEncoding.default
            
            var json : NSData = NSData()
            var jsonString: String
            json = try! JSONSerialization.data(withJSONObject: route.parameters!, options: JSONSerialization.WritingOptions(rawValue: 0)) as NSData
            print(json)
            
            jsonString = NSString(data: json as Data, encoding: UInt(String.Encoding.utf8.hashValue))! as String
            
            parameter = [route.keys! : jsonString] as [String : Any]
        }
        
        return self.request(path!, method: route.method, parameters: parameter, encoding: encoding, headers: header)
    }
}

struct PSAPIResponse: JSONable
{
    //MARK: - Properties
    let code    : Int!
    let message : String!
    
    //MARK: - Methods
    init?(parameter: JSON)
    {
        code          = parameter[PSAPI.RKey.Code].intValue
        message       = parameter[PSAPI.RKey.Message].stringValue
    }
}

