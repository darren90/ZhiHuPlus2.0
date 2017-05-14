//
//  APINetTools.swift
//  ZhiHuPlus2.0
//
//  Created by Tengfei on 16/2/28.
//  Copyright © 2016年 tengfei. All rights reserved.
//

import UIKit
import Alamofire
//import Alamofire
import SwiftyJSON


class APINetTools: NSObject {
    static let baseUrl = ""
    
    func test()  {
        
    }
 
    /**
     GET请求的方式
     
     - parameter url:     url
     - parameter params:  参数，字典类型
     - parameter success: 成功的回调
     - parameter fail:    失败
     */
    static func get(_ url:String,params:[String:AnyObject]?,success:@escaping (_ json:AnyObject) -> Void,fail:@escaping (_ error:Any) -> Void){
        let urlStr = baseUrl + url
        
        
        if let paramss = params{
            
            Alamofire.request(.GET,urlStr, parameters: paramss).responseJSON { (_, _, result) -> Void in
                switch result {
                case let .success(json):
                    //print(json)
                    success(json: json)
                case let .failure(_, error):
                    //print(error)
                    fail(error: error)
                }
            }
        }else{
            Alamofire.request(.GET,urlStr).responseJSON { (_, _, result) -> Void in
                switch result {
                case let .success(json):
                    //                    print(json)
                    success(json: json)
                case let .failure(_, error):
                    //                    print(error)
                    fail(error: error)
                }
            }
        }
    }
    
    /**
     POST请求的方式
     
     - parameter url:     url
     - parameter params:  参数，字典类型
     - parameter success: 成功的回调
     - parameter fail:    失败
     */
    static func post(_ url:String,params:[String:AnyObject]?,success:@escaping (_ json:AnyObject) -> Void,fail:@escaping (_ error:Any) -> Void){
        let urlStr = baseUrl + url
        
        if let paramss = params{
            Alamofire.request(.POST,urlStr, parameters: paramss).responseJSON { (_, _, result) -> Void in
                switch result {
                case let .success(json):
                    //                    print(json)
                    success(json: json)
                case let .failure(_, error):
                    //                    print(error)
                    fail(error: error)
                }
            }
        }else{
            Alamofire.request(.POST,urlStr).responseJSON { (request, response, result) -> Void in
                switch result {
                case let .success(json):
                    //                    print(json)
                    success(json: json)
                case let .failure(_, error):
                    //                    print(error)
                    fail(error: error)
                }
            }
        }
    }
}
