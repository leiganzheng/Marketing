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
    "http://cvsapi.1g9f.com"
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
//        request.addValue(APP_VERSION, forHTTPHeaderField: "VER")        // 客户端版本号
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
                
                let errorCode = Int((dictionary!["ret"] as! NSNumber))
                if  errorCode == 0 {
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
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let user = User(dictionary!)
                saveAccountAndPassword(account, password: password)
                saveObjectToUserDefaults("UserPic", value: user.picture!)
                completion(user, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     退出登录，并且拥有页面跳转功能
     */
    class func logout(accesstoken: String, completion: (succeed: Bool, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Apibase/userLogout", parameters: ["accesstoken" : accesstoken]) { (_, _, _, dictionary, error) -> Void in
            let succeed: Bool
            if let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                succeed = true
            }
            else {
                succeed = false
            }
            completion(succeed: succeed, error, dictionary?["errorMsg"] as? String)
            let vc = (UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!)
            QNTool.enterRootViewController(vc)
        }
    }

    /**
     获取验证码
     
     :param: flag 标记默认为Other（其他-Other、注册-Register）（注册时为Register[必选项]）
     :param: role 身份默认为3（站长-1、商家-2、客户-3）
     :param: type  类型默认为0（手机-0、邮箱-1）
     :param: target 账号（手机类型时填手机号码、邮箱类型时填邮件地址）[必选项]
     :param: completion 完成的回调（内涵验证码）
     */
    class func fetchAuthCode(role: String, type: String,flag:String,target: String, completion: (AnyObject!, NSError!, String!) -> Void) {
        requestPOST(kServerAddress + "/Apibase/sendCaptcha", parameters: ["type" : type, "target" : target,"role":role,"flag":flag]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                completion(dictionary?["code"], nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
        }
    }
    
    /**
     021.注册接口
     
     :param: adminuser                姓名
     :param: password            密码
     :param: authcode            验证码
     :param: completion          完成的回调
     */
    class func register(adminuser: String, password: String, authcode: String, completion: (User!, NSError!, String!) -> Void) {
        var params = [String : String]()
        params["adminuser"] = adminuser
        params["adminpass"] = password
        params["code"] = authcode
        requestPOST(kServerAddress + "/Customersapi/customerSave", parameters:params) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let user = User(dictionary!)
                g_user = user
                completion(user, nil, nil)
            }else {
                completion(nil, error, dictionary?["errormsg"] as? String)
            }
        }
    }
    /**
     获取用户信息
     :param: string accesstoken 登录状态校验令牌
     :param: completion 完成的回调 
     */
    class func fetchUserinfo(role: String, type: String,target: String, completion: (User?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Apibase/userGetInfo", parameters: ["type" : type, "target" : target,"role":role]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let user = User(dictionary!)
                completion(user, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }

        }
    }
    /**
     获取用户信息
     :param: string accesstoken 登录状态校验令牌
     :param: string accesstoken 登录状态校验令牌
     :param: string accesstoken 登录状态校验令牌
     :param: string accesstoken 登录状态校验令牌
     :param: string accesstoken 登录状态校验令牌
     :param: string accesstoken 登录状态校验令牌
     
     :param: completion 完成的回调 
     */
    class func updateUserinfo(role: String, type: String,target: String, completion: (User?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Customersapi/customerSave", parameters: ["type" : type, "target" : target,"role":role]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let user = User(dictionary!)
                completion(user, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
            
        }
    }

    /**
     用户修改密码
     :param:  accesstoken 登录状态校验令牌
     :param:  oldpwd
     :param:  newpwd
     :param: completion 完成的回调 
     */
    class func updatePassWord(accesstoken: String, old: String,new: String, completion: (succeed: Bool, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Apibase/userPasswordEdit", parameters: ["accesstoken" : accesstoken, "old_password" : old,"new_password":new]) { (_, _, _, dictionary, error) -> Void in
            let succeed: Bool
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                succeed = true
            }
            else {
                succeed = false
            }
            completion(succeed: succeed, error, dictionary?["errorMsg"] as? String)
        }
    }
    /**
     用户找回密码
     :param: type 类型默认为0（手机-0、邮箱-1）
     :param: code 验证码[必选项]
     :param: role 身份默认为3（站长-1、商家-2、客户-3）
     :param: account 账号[必选项]
     :param: new_password 密码[必选项]
     :param: completion 完成的回调 
     */
    class func findPassWord(role: String, type: String,account: String,code: String,new_password: String, completion: (succeed: Bool, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Apibase/userPasswordForgot", parameters: ["role" : role, "type" : type,"code" : code,"new_password" : new_password,"account":account]) { (_, _, _, dictionary, error) -> Void in
            let succeed: Bool
            if let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                succeed = true
            }
            else {
                succeed = false
            }
            completion(succeed: succeed, error, dictionary?["errorMsg"] as? String)
        }
    }
}
//MARK:- 商家模块
extension QNNetworkTool {
    /**
     商家列表
     :param: search_key 搜索关键词
     :param: page 页码[必选项]
     :param: page_size 页数默认10
     :param: order 排序默认按shop_id
     :param: completion 完成的回调 
     */
    class func fetchShopList(search_key: String, page: String,page_size: String, order:String, completion: ([Shop]?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Shopsapi/shopGetList", parameters: ["search_key" : search_key, "page" : page,"page_size":page_size,"order":order]) { (_, _, _, dictionary, error) -> Void in
            if let userList = dictionary?["data"] as? NSArray {
                var result = [Shop]()
                for object in userList {
                    if let dic = object as? NSDictionary, let shop = Shop(dic) {
                        result.append(shop)
                    }
                }
                completion(result, error, dictionary?["errorMsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }

            
        }
    }
    /**
     商家详情
     :param: shop_id 商家ID
     :param: completion 完成的回调 
     */
    class func fetchShopDetailInfo(shop_id: String, completion: (Shop?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Shopsapi/shopGetInfo", parameters: ["shop_id" : shop_id]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let shop = Shop(dictionary!)
                completion(shop, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
      商家保存（申请、新增、修改）
     :param: dictionary 商家ID
     :param: completion 完成的回调
     */
    class func saveShopInfo(dictionary: String, completion: (Shop?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Shopsapi/shopSave", parameters: ["dictionary" : dictionary]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let shop = Shop(dictionary!)
                completion(shop, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }

}