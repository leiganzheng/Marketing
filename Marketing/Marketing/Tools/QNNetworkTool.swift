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
                g_user = user
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
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let userList = dictionary?["data"] as? NSArray
                var result = [Shop]()
                for object in userList! {
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
    /**
     分类列表
     :param: completion 完成的回调
     */
    class func fetchCategoryList(completion: ([Category]?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Categoryapi/categoryGetList", parameters: nil) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let userList = dictionary?["data"] as? NSArray
                var result = [Category]()
                for object in userList! {
                    if let dic = object as? NSDictionary, let category = Category(dic) {
                        result.append(category)
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
     商品列表
     :param: shop_id 商店ID
     :param: cat_id 分类ID
     :param: shop_cat_id 店内分类ID
     :param: name 商品名称
     :param: verify 认证状态：1 验证中 2 验证通过 3 验证不通过
     :param: status 状态：-1 删除 1 未上架 2 上架 3 下架 4 禁用
     :param: page 页码默认1[必选项]
     :param: page_size 页数默认10
     :param: completion 完成的回调
     */
    class func fetchGoodList(shop_id: String,cat_id: String,shop_cat_id: String,name: String,verify: String,status:String, page: String,page_size: String, order:String, completion: ([Good]?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Goodsapi/goodsGetList", parameters: ["shop_id" : shop_id, "page" : page,"page_size":page_size, "cat_id" : cat_id,"shop_cat_id":shop_cat_id, "name" : name,"verify":verify,"status":status]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let userList = dictionary?["data"] as? NSArray
                var result = [Good]()
                for object in userList! {
                    if let dic = object as? NSDictionary, let good = Good(dic) {
                        result.append(good)
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
     商品详情
     :param: good_id ID
     :param: completion 完成的回调
     */
    class func fetchGoodDetailInfo(good_id: String, completion: (Good?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Goodsapi/goodsGetInfo", parameters: ["good_id" : good_id]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let shop = Good(dictionary!)
                completion(shop, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     广告列表
     :param: completion 完成的回调
     */
    class func fetchAdList(completion: ([AdModel]?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Adapi/adGetList", parameters: nil) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let userList = dictionary?["data"] as? NSArray
                var result = [AdModel]()
                for object in userList! {
                    if let dic = object as? NSDictionary, let category = AdModel(dic) {
                        result.append(category)
                    }
                }
                completion(result, error, dictionary?["errorMsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
            
            
        }
    }
}
//MARK:- 促销模块
extension QNNetworkTool {
    /**
     分类列表
     :param: completion 完成的回调
     */
    class func fetchPromotionList(completion: (NSArray?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Promotionapi/promotionGetList", parameters: nil) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let userList = dictionary?["data"] as? NSArray
                completion(userList, error, dictionary?["errorMsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
            
            
        }
    }

}
//MARK:- BusinessCategory (行业分类模块)
extension QNNetworkTool {
    /**
     行业分类列表
     :param: completion 完成的回调
     */
    class func fetchBusinessCategoryList(completion: ([BusinessCategory]?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/BusinessCategoryapi/businessCategoryGetList", parameters: nil) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let userList = dictionary?["data"] as? NSArray
                var result = [BusinessCategory]()
                for object in userList! {
                    if let dic = object as? NSDictionary, let category = BusinessCategory(dic) {
                        result.append(category)
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
     添加行业分类
     :param: completion 完成的回调
     */
    class func businessCategoryAdd(accesstoken:String,name:String,description:String,picture:String,parent:String,sort:String, completion: (BusinessCategory?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/BusinessCategoryapi/businessCategoryAdd", parameters: ["accesstoken":accesstoken,"name":name,"description":description,"picture":picture,"parent":parent,"sort":sort]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                completion(BusinessCategory(dictionary!), error, dictionary?["errorMsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }
    /**
     更新行业分类
     :param: completion 完成的回调
     */
    class func businessCategoryUpdate(accesstoken:String,name:String,description:String,picture:String,parent:String,sort:String, completion: (BusinessCategory?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/BusinessCategoryapi/businessCategoryUpdate", parameters: ["accesstoken":accesstoken,"name":name,"description":description,"picture":picture,"parent":parent,"sort":sort]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                completion(BusinessCategory(dictionary!), error, dictionary?["errorMsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
        }
    }
}

//MARK:- 订单模块
extension QNNetworkTool {
    /**
     订单列表
     :param: completion 完成的回调
     */
    class func fetchOrderList(uid:String, accesstoken: String,page: String,page_size: String, completion: ([Order]?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Orderapi/orderGetList", parameters: ["uid" : uid, "page" : page,"page_size":page_size, "accesstoken" : accesstoken]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let list = dictionary?["data"] as? NSArray
                var result = [Order]()
                for object in list! {
                    if let dic = object as? NSDictionary, let order = Order(dic) {
                        result.append(order)
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
     订单详情
     :param: completion 完成的回调
     */
    class func fetchOrderInfo(order_id:String, accesstoken: String, completion: (Order?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Orderapi/orderGetInfo", parameters: ["order_id" : order_id,"accesstoken" : accesstoken]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let order = Order(dictionary!)
                completion(order, error, dictionary?["errorMsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
            
        }
    }
    /**
     添加订单
     :param:  accesstoken 登录状态校验令牌[必选项]
     :param:  shop_id 商店ID
     :param:  uid 用户ID
     :param:  goods_price 商品总价格
     :param:  order_price 订单总价格
     :param:  customer_address_id 用户地址ID
     :param:  order_goods 订单商品，为数组json化格式
     :param: completion 完成的回调
     */
    class func orderAdd(shop_id:String, accesstoken: String,uid: String,goods_price: String,order_price: String,customer_address_id: String, order_goods: String, completion: (Order?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Orderapi/orderAdd", parameters: ["shop_id" : shop_id,"uid" : uid,"goods_price" : goods_price,"order_price" : order_price,"customer_address_id" : customer_address_id,"accesstoken" : accesstoken,"order_goods" : order_goods]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let order = Order(dictionary!)
                completion(order, error, dictionary?["errorMsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errorMsg"] as? String)
            }
            
        }
    }


    
}

