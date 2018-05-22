//
//  PSWebSevice+User.swift
//  ProjectStructure
//
//  Created by Nectarbits on 23/03/17.
//  Copyright © 2017 nectarbits. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension PSWebService
{
    func GetUserDetailAPI(completion:@escaping ([String:AnyObject]) -> Void)
    {
        self.sendRequest(.GetUserDetail()).responseJSON { response in
            
            switch response.result
            {
            case .success:
                if let _ = response.result.value
                {
                    let data = response.data
                    var dictonary = [String:AnyObject]()
                    do {
                        dictonary =  (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject])!
                    
                    } catch let error as NSError {
                    print(error)
                    }
                    
                    completion(dictonary)
                }
                
            case .failure(let error):
                
                print("Error: \(error)")
                completion([:])
            }
        }
    }
    
    func GetUserPhotosAPI(completion:@escaping ([String:AnyObject]) -> Void)
    {
        self.sendRequest(.GetUserPhotos()).responseJSON { response in
            
            switch response.result
            {
            case .success:
                if let _ = response.result.value
                {
                    let data = response.data
                    var dictonary = [String:AnyObject]()
                    do {
                        dictonary =  (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject])!
                        
                    } catch let error as NSError {
                        print(error)
                    }
                    
                    completion(dictonary)
                }
                
            case .failure(let error):
                
                print("Error: \(error)")
                completion([:])
            }
        }
    }
    
    func UserRegisterAPI(_ parameter: [String:Any] ,completion:@escaping ([String:AnyObject]) -> Void)
    {
        self.sendRequest(.UserRegister(parameter)).responseJSON { response in
            
            switch response.result
            {
            case .success:
                if let _ = response.result.value
                {
                    let data = response.data
                    var dictonary = [String:AnyObject]()
                    do {
                        dictonary =  (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject])!
                        completion(dictonary)
                    } catch let error as NSError {
                        print(error)
                        completion(["Error":error.localizedDescription as AnyObject])
                    }
                    
                    
                }
                
            case .failure(let error):
                
                print("Error: \(error)")
                completion(["Error":error.localizedDescription as AnyObject])
            }
        }
    }
    
    func StoreTransactionAPI(_ parameter: [String:Any] ,completion:@escaping ([String:AnyObject]) -> Void)
    {
        self.sendRequest(.storeTransaction(parameter)).responseJSON { response in
            
            switch response.result
            {
            case .success:
                if let _ = response.result.value
                {
                    let data = response.data
                    var dictonary = [String:AnyObject]()
                    do {
                        dictonary =  (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject])!
                        completion(dictonary)
                    } catch let error as NSError {
                        print(error)
                        completion(["Error":error.localizedDescription as AnyObject])
                    }
                    
                    
                }
                
            case .failure(let error):
                
                print("Error: \(error)")
                completion(["Error":error.localizedDescription as AnyObject])
            }
        }
    }
    
    func ShowTransactionsAPI(_ parameter: [String:Any] ,completion:@escaping ([String:AnyObject]) -> Void)
    {
        self.sendRequest(.showTransactions(parameter)).responseJSON { response in
            
            switch response.result
            {
            case .success:
                if let _ = response.result.value
                {
                    let data = response.data
                    var dictonary = [String:AnyObject]()
                    do {
                        dictonary =  (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject])!
                        completion(dictonary)
                    } catch let error as NSError {
                        print(error)
                        completion(["Error":error.localizedDescription as AnyObject])
                    }
                    
                    
                }
                
            case .failure(let error):
                
                print("Error: \(error)")
                completion(["Error":error.localizedDescription as AnyObject])
            }
        }
    }
}
