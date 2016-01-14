//
//  QNNetworkTool.swift
//  QooccHealth
//
//  Created by Leiganzheng on 15/4/8.
//  Copyright (c) 2015年 Leiganzheng. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - 315便利客服务器地址
private let (kServerAddress) = { () -> (String) in
    // 正式环境
    " http://cvsapi.1g9f.com"
    // 测试环境
    //" http://cvsapi.1g9f.com"
}()
/**
 *  //MARK:- 网络处理中心
 */
class QNNetworkTool: NSObject {
}
/**
 *  //MARK:- 网络基础处理
 */
private extension QNNetworkTool {
    /**
     //MARK: 生产共有的 URLRequest
     
     :param: url    请求的地址
     :param: method 请求的方式， Get Post Put ...
     */
    private class func productRequest(url: NSURL!, method: NSString!) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.addValue(g_user?.accesstoken ?? "", forHTTPHeaderField: "AUTH") // 用户身份串,在调用/api/login 成功后会返回这个串;未登录时为空
//        request.addValue("1", forHTTPHeaderField: "AID")                // app_id, iphone=1, android=2
        request.addValue(APP_VERSION, forHTTPHeaderField: "VER")        // 客户端版本号
//        request.addValue(g_UDID, forHTTPHeaderField: "CID")             // 客户端设备号
        request.HTTPMethod = method as String
        return request
    }
    
    //MARK: 后台返回的数据错误，格式不正确 的 NSError
    private class func formatError() -> NSError {
        return NSError(domain: "后台返回的数据错误，格式不正确", code: 10087, userInfo: nil)
    }
    
    /**
     //MARK: Request 请求通用简化版
     
     :param: url               请求的服务器地址
     :param: method            请求的方式 Get/Post/Put/...
     :param: parameters        请求的参数
     :param: completionHandler 请求完成后的回掉， 如果 dictionary 为nil，那么 error 就不可能为空
     */
    private class func requestForSelf(url: NSURL?, method: String, parameters: [String : AnyObject]?, completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, dictionary: NSDictionary?, error: NSError?) -> Void) {
        request(ParameterEncoding.URL.encode(self.productRequest(url, method: method), parameters: parameters).0).response {
            do  {
                let errorJson: NSErrorPointer = nil
                let jsonObject: AnyObject? = try  NSJSONSerialization.JSONObjectWithData($2!, options: NSJSONReadingOptions.MutableContainers)
                let dictionary = jsonObject as? NSDictionary
                if dictionary == nil {  // Json解析结果出错
                    completionHandler(request: $0!, response: $1, data: $2, dictionary: nil, error: NSError(domain: "JSON解析错误", code: 10086, userInfo: nil)); return
                }
                
                let errorCode = Int((dictionary!["errorCode"] as! String))
                if errorCode == 1000 || errorCode == 0 {
                    completionHandler(request: $0!, response: $1, data: $2, dictionary: dictionary, error: nil)
                }
                else {
                    completionHandler(request: $0!, response: $1, data: $2, dictionary: dictionary, error: NSError(domain: "服务器返回错误", code:errorCode ?? 10088, userInfo: nil))
                }
                if dictionary == nil {  // Json解析结果出错
                    completionHandler(request: $0!, response: $1, data: $2, dictionary: nil, error: errorJson.memory); return
                }
            }catch {
                // 直接出错了
                completionHandler(request: $0!, response: $1, data: $2, dictionary: nil, error: $3); return
            }
            
        }
    }
    
    /**
     //MARK: Get请求通用简化版
     
     :param: urlString         请求的服务器地址
     :param: parameters        请求的参数
     :param: completionHandler 请求完成后的回掉
     */
    private class func requestGET(urlString: String, parameters: [String : AnyObject]?, completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?,  dictionary: NSDictionary?, error: NSError?) -> Void) {
        let url: NSURL! = NSURL(string: urlString)
        assert((url != nil), "输入的url有问题")
        requestForSelf(url, method: "Get", parameters: parameters, completionHandler: completionHandler)
    }
    
    /**
     //MARK: Post请求通用简化版
     
     :param: urlString         请求的服务器地址
     :param: parameters        请求的参数
     :param: completionHandler 请求完成后的回掉
     */
    private class func requestPOST(urlString: String, parameters: [String : AnyObject]?, completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?,  dictionary: NSDictionary?, error: NSError?) -> Void) {
        let url: NSURL! = NSURL(string: urlString)
        assert((url != nil), "输入的url有问题")
        requestForSelf(url, method: "POST", parameters: parameters, completionHandler: completionHandler)
    }
    
    /**
     //MARK: 将输入参数转换成字符传
     */
    private class func paramsToJsonDataParams(params: [String : AnyObject]) -> [String : AnyObject] {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
            let jsonDataString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            return ["jsonData" : jsonDataString]
        }catch{
            return ["jsonData" : ""]
        }
    }
}
//MARK:- 用户中心
extension QNNetworkTool {
    /**
     登录接口
     
     :param: account       登录Id
     :param: password 登录密码
     :param: role 身份（站长-1、商家-2、客户-3）
     :param: completion    请求完成后的回掉
     */

    class func login(Account account: String, Password password: String,Role role: String, completion: (User?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Apibase/userLogin", parameters: ["account" : account, "password" : password,"role":role]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let userDic = dictionary?["data"] as? NSDictionary, let doctor = User(userDic) {
                completion(doctor, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     获取验证码
     
     :param: role 身份默认为3（站长-1、商家-2、客户-3）
     :param: type  类型默认为0（手机-0、邮箱-1）
     :param: target 账号（手机类型时填手机号码、邮箱类型时填邮件地址）[必选项]
     :param: completion 完成的回调（内涵验证码）
     */
    class func fetchAuthCode(role: String, type: String,target: String, completion: (String?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Apibase/sendCaptcha", parameters: ["type" : type, "target" : target,"role":role]) { (_, _, _, dictionary, error) -> Void in
            if let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                completion(dictionary?["code"] as? String, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
        }
    }
    
    /**
     021.医生注册接口
     
     :param: name                姓名
     :param: phone               电话号码
     :param: password            密码
     :param: authcode            验证码
     :param: completion          完成的回调
     */
//    class func register(name: String, phone: String, password: String, authcode: String, completion: (QD_Doctor?, NSError?, String?) -> Void) {
//        var params = [String : String]()
//        params[""] = name
//        params["phone"] = phone
//        params["password"] = password
//        params["authcode"] = authcode
//        requestPOST(kServerAddress + "/Customersapi/customerSave", parameters: paramsToJsonDataParams(params)) { (_, _, _, dictionary, error) -> Void in
//            if dictionary != nil, let userDic = dictionary?["data"] as? NSDictionary, let user = User(userDic) {
//                g_user = user
//                completion(user, nil, nil)
//            }else {
//                completion(nil, error, dictionary?["errorMsg"] as? String)
//            }
//        }
//    }


}