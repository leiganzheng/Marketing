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
        requestPOST(kServerAddress + "/Apibase/userLogin", parameters: ["account" : account, "password" : password.MD5(),"role":role]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let user = User(dictionary!)
                g_user = user
                saveAccountAndPassword(account, password: password)
                saveObjectToUserDefaults("UserPic", value: user.picture!)
                completion(user, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
            completion(succeed: succeed, error, dictionary?["errmsg"] as? String)
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
        params["adminpass"] = password.MD5()
        params["code"] = authcode
        requestPOST(kServerAddress + "/Customersapi/customerSave", parameters:params) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let user = User(dictionary!)
                g_user = user
                completion(user, nil, nil)
            }else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(nil, error, dictionary?["errmsg"] as? String)
            }

        }
    }
    /**
     更新用户信息
     :param:  accesstoken 登录状态校验令牌（修改时[必选项]）
     :param:  code 验证码（注册时[必选项]）
     :param:  uid 用户ID（修改时[必选项]）
     :param:  adminuser 帐号（手机号码）[必选项]
     :param:  adminpass 密码（MD5）[必选项]
     :param:  nickname 昵称
     :param:  mobile 手机
     :param:  birthday 出生日期
     :param:  gender 性别
     :param:  picture 头像
     :param:  status 状态默认0为正常
     
     :param: completion 完成的回调 
     */
    class func updateUserInfo(uid:String,adminuser:String,nickname:String,mobile:String,picture:String,completion: (User?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Customersapi/customerSave", parameters: ["accesstoken" : (g_user?.accesstoken)!, "uid" : uid,"adminuser":adminuser,"adminpass":(g_user?.adminpass?.MD5())!,"nickname":nickname,"mobile":mobile,"picture":picture]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let user = User(dictionary!)
                completion(user, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
        requestPOST(kServerAddress + "/Apibase/userPasswordEdit", parameters: ["accesstoken" : accesstoken, "old_password" : old.MD5(),"new_password":new.MD5()]) { (_, _, _, dictionary, error) -> Void in
            let succeed: Bool
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                succeed = true
            }
            else {
                succeed = false
            }
            completion(succeed: succeed, error, dictionary?["errmsg"] as? String)
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
        requestPOST(kServerAddress + "/Apibase/userPasswordForgot", parameters: ["role" : role, "type" : type,"code" : code,"new_password" : new_password.MD5(),"account":account]) { (_, _, _, dictionary, error) -> Void in
            let succeed: Bool
            if let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                succeed = true
            }
            else {
                succeed = false
            }
            completion(succeed: succeed, error, dictionary?["errmsg"] as? String)
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
     :param:  business_cat_id 行业ID
     :param:  need_shop_address 1 返回店铺地址 0 不返回（当选择这个参数，只有有地址的店铺会被返回）
     :param: completion 完成的回调 
     */
    class func fetchShopList(search_key: String, page: String,business_cat_id: String,need_shop_address: String,page_size: String, order:String, completion: ([Shop]?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Shopsapi/shopGetList", parameters: ["search_key" : search_key, "page" : page,"page_size":page_size,"order":order,"need_shop_address":need_shop_address,"business_cat_id":business_cat_id]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let userList = dictionary?["data"] as? NSArray
                var result = [Shop]()
                for object in userList! {
                    if let dic = object as? NSDictionary, let shop = Shop(dic) {
                        result.append(shop)
                    }
                }
                completion(result, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }

            
        }
    }
    /**
     商家详情
     :param:  shop_id 商家ID
     :param:  need_shop_category 1 返回店内分类列表 0 不返回
     :param:  need_shop_goods 1 返回店内商品列表 0 不返回
     :param: completion 完成的回调 
     */
    class func fetchShopDetailInfo(shop_id: String,needCategory:String,needGoods:String, completion: (Shop?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Shopsapi/shopGetInfo", parameters: ["shop_id" : shop_id,"need_shop_goods":needGoods,"need_shop_category":needCategory]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let shop = Shop(dictionary!)
                completion(shop, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
        }
    }
    /**
      商家保存（申请、新增、修改）
     :param: dictionary 商家ID
     :param: adminpass 商家密码（MD5）[必选项]
     :param: completion 完成的回调
     */
    class func saveShopInfo(dictionary: String, completion: (Shop?, NSError?, String?) -> Void) {
        requestPOST(kServerAddress + "/Shopsapi/shopSave", parameters: ["dictionary" : dictionary]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil, let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let shop = Shop(dictionary!)
                completion(shop, nil, nil)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(result, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
            
            
        }
    }
    /**
     商品列表
     :param: shop_id 商店ID
     :param: cat_id 分类ID
     :param: shop_cat_id 店内分类ID
     :param: promotion_type 促销类型ID
     :param: name 商品名称
     :param: verify 认证状态：1 验证中 2 验证通过 3 验证不通过
     :param: status 状态：-1 删除 1 未上架 2 上架 3 下架 4 禁用
     :param: page 页码默认1[必选项]
     :param: page_size 页数默认10
     :param: completion 完成的回调
     */
    class func fetchGoodList(shop_id: String,cat_id: String,shop_cat_id: String,promotion_type:String,name: String,verify: String,status:String, page: String,page_size: String, order:String, completion: ([Good]?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Goodsapi/goodsGetList", parameters: ["shop_id" : shop_id, "promotion_type" : promotion_type, "page" : page,"page_size":page_size, "cat_id" : cat_id,"shop_cat_id":shop_cat_id, "name" : name,"verify":verify,"status":status]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0 {
                let userList = dictionary?["data"] as? NSArray
                var result = [Good]()
                for object in userList! {
                    if let dic = object as? NSDictionary, let good = Good(dic) {
                        result.append(good)
                    }
                }
                completion(result, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(result, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(userList, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(result, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(BusinessCategory(dictionary!), error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(BusinessCategory(dictionary!), error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
        }
    }
}

//MARK:- 订单模块
extension QNNetworkTool {
    /**
     订单列表
     :param:  accesstoken 登录状态校验令牌[必选项]
     :param:  order_id 订单ID
     :param:  shop_id 商店ID
     :param:  uid 用户ID
     :param:  payment_id 支付渠道ID
     :param:  pay_sn 支付sn
     :param:  evaluation_status 评价状态：0 未评价 1 已评价 2 过期未评价
     :param:  shipping_code 物流单号
     :param:  customer_address 收货地址
     :param:  status 状态：-1 删除 0 未支付 1 已支付 2 已发货 3 已收货 4 取消订单 5 申请退款 6 已退款
     :param:  need_order_goods 1 返回下单的商品 0 不返回
     :param:  page 页码默认1
     :param:  page_size 页数默认10
     :param: completion 完成的回调
     */
    class func fetchOrderList(order_id:String,shop_id:String,uid:String,payment_id:String,pay_sn:String,evaluation_status:String,shipping_code:String,customer_address:String,status:String,need_order_goods:String, accesstoken: String,page: String,page_size: String, completion: ([Order]?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Orderapi/orderGetList", parameters: ["order_id" : order_id, "page" : page,"page_size":page_size, "accesstoken" : accesstoken,"shop_id" : shop_id,"uid" : uid,"payment_id" : payment_id,"pay_sn" : pay_sn,"evaluation_status" : evaluation_status,"shipping_code" : shipping_code,"customer_address" : customer_address,"status" : status,"need_order_goods" : need_order_goods]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let list = dictionary?["data"] as? NSArray
                var result = [Order]()
                for object in list! {
                    if let dic = object as? NSDictionary, let order = Order(dic) {
                        result.append(order)
                    }
                }

                completion(result, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(order, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
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
                completion(order, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
            
        }
    }
    
}
//MARK:- (店内分类模块)
extension QNNetworkTool {
    /**
     订单详情
     :param: completion 完成的回调
     */
    class func fetchShopCategoryList(completion: ([ShopCategory]?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Shopcategoryapi/shopCategoryGetList", parameters: nil) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let list = dictionary?["data"] as? NSArray
                var result = [ShopCategory]()
                for object in list! {
                    if let dic = object as? NSDictionary, let order = ShopCategory(dic) {
                        result.append(order)
                    }
                }
                completion(result, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
            
        }
    }

}
//MARK:- CustomerAddress (客户地址模块)
extension QNNetworkTool {
    /**
     客户地址列表
     :param:  accesstoken 登录状态校验令牌[必选项]
     :param:  status 状态：-1 删除 0 正常 1 默认使用 2 禁用
     :param: completion 完成的回调
     */
    class func customerAddressGetList(accesstoken:String,status:String, completion: ([Address]?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Customeraddressapi/customerAddressGetList", parameters: ["accesstoken":accesstoken,"status":status]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let list = dictionary?["data"] as? NSArray
                var result = [Address]()
                for object in list! {
                    if let dic = object as? NSDictionary, let address = Address(dic) {
                        result.append(address)
                    }
                }
                completion(result, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
            
        }
    }
    /**
     客户地址详情
     :param:  accesstoken 登录状态校验令牌[必选项]
     :param:  id 客户地址ID[必选项]
     :param:  status 状态：-1 删除 0 正常 1 默认使用 2 禁用
     :param: completion 完成的回调
     */
    class func customerAddressGetInfo(accesstoken:String,status:String,id:String, completion: (Address?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Customeraddressapi/customerAddressGetInfo", parameters: ["accesstoken":accesstoken,"status":status,"id":id]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let address = Address(dictionary!)
                completion(address, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
            
        }
    }
    /**
     客户地址添加
     :param:  accesstoken 登录状态校验令牌[必选项]
     :param:   mobile 联系电话[必选项]
     :param:   longitude 经度
     :param:   latitude 纬度
     :param:   address 所在乡镇
     :param:   address_detail 所在街道
     :param: completion 完成的回调
     */
    class func customerAddressAdd(accesstoken:String,mobile:String,longitude:String,latitude:String,address:String,address_detail:String, completion: (Address?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Customeraddressapi/CustomerAddressAdd", parameters: ["accesstoken":accesstoken,"mobile":mobile,"longitude":longitude,"latitude":latitude,"address":address,"address_detail":address_detail]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let address = Address(dictionary!)
                completion(address, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
            
        }
    }
    /**
     客户地址更新
     :param:  accesstoken 登录状态校验令牌[必选项]
     :param:   mobile 联系电话[必选项]
     :param:   longitude 经度
     :param:   latitude 纬度
     :param:   address 所在乡镇
     :param:   address_detail 所在街道
     :param:    id 客户地址ID[必选项]
     :param:    status 状态：-1 删除 0 正常 1 默认使用 2 禁用
     :param: completion 完成的回调
     */
    class func customerAddressUpdate(accesstoken:String,id:String,status:String,mobile:String,longitude:String,latitude:String,address:String,address_detail:String, completion: (Address?, NSError?, String?) -> Void) {
        requestGET(kServerAddress + "/Customeraddressapi/customerAddressUpdate", parameters: ["accesstoken":accesstoken,"mobile":mobile,"longitude":longitude,"latitude":latitude,"address":address,"address_detail":address_detail,"id":id,"status":status]) { (_, _, _, dictionary, error) -> Void in
            if dictionary != nil,let errorCode = dictionary?["ret"]?.integerValue where errorCode == 0  {
                let address = Address(dictionary!)
                completion(address, error, dictionary?["errmsg"] as? String)
            }
            else {
                completion(nil, error, dictionary?["errmsg"] as? String)
            }
            
        }
    }


    
}
