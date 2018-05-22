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
    var header = ["Content-Type" : "application/json"]
    
    static let APIClient: PSWebService =
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 180
        configuration.timeoutIntervalForRequest  = 180
        
        return PSWebService(configuration: configuration)
    }()
    
    func sendRequest(_ route: Router)
        -> DataRequest
    {
        let path = route.path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
            
        let encoding: ParameterEncoding = JSONEncoding.default
        
        return self.request(path!, method: route.method, parameters: route.parameters, encoding: encoding, headers: header)
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

