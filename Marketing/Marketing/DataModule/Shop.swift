//
//  Shop.swift
//  Marketing
//
//  Created by leiganzheng on 16/1/14.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import Foundation
class Shop: QN_Base {
    
    private(set) var shop_id: String!          // Id
    private(set) var name: String?        // 名称
    private(set) var accesstoken: String!              // 登录状态校验令牌
    private(set) var adminuser: String? //（******占位符管理中心专属）
    private(set) var adminpass: String?
    
    private(set) var picture: String?
    private(set) var birthday: String?
    private(set) var gender: String?
    private(set) var login_time: String?
    private(set) var create_time: String?
    private(set) var update_time: String?
    private(set) var status: String?
    private(set) var role: String?        // 身份（站长-1、商家-2、客户-3）
    
    private(set) var tel: String?
    private(set) var rate: String?
    private(set) var info: String?
    private(set) var fee: String?
    private(set) var discount: String?
    private(set) var hours: String?
    private(set) var manager: String?
    private(set) var mobile: String?
    private(set) var identification: String?
    private(set) var identification_picture: String?
    private(set) var credential: String?
    private(set) var pass_time: String?
    private(set) var sort: String?
    
    required init!(_ dictionary: NSDictionary) {
        // 先判断存在性
        if !QN_Base.existValue(dictionary, keys: "shop_id") {
            super.init(dictionary)
            return nil
        }
        // 所需要的数据都存在，则开始真正的数据初始化
        self.shop_id = dictionary["shop_id"] as! String
        self.name = dictionary["name"] as? String
        self.accesstoken = dictionary["accesstoken"] as! String
        self.adminuser = dictionary["adminuser"] as? String
        self.adminpass = dictionary["adminpass"] as? String
        self.picture = dictionary["picture"] as? String
        self.birthday = dictionary["birthday"] as? String
        self.gender = dictionary["gender"] as? String
        self.login_time = dictionary["login_time"] as? String
        self.create_time = dictionary["create_time"] as? String
        self.update_time = dictionary["update_time"] as? String
        self.status = dictionary["status"] as? String
        self.role = dictionary["role"] as? String
        self.tel = dictionary["tel"] as? String
        self.rate = dictionary["rate"] as? String
        self.info = dictionary["info"] as? String
        self.fee = dictionary["fee"] as? String
        self.discount = dictionary["discount"] as? String
        self.hours = dictionary["hours"] as? String
        self.manager = dictionary["manager"] as? String
        self.mobile = dictionary["mobile"] as? String
        self.identification = dictionary["identification"] as? String
        self.identification_picture = dictionary["identification_picture"] as? String
        self.credential = dictionary["credential"] as? String
        self.pass_time = dictionary["pass_time"] as? String
        self.sort = dictionary["sort"] as? String
        super.init(dictionary)
    }
    
    override func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.addEntriesFromDictionary(super.dictionary() as [NSObject : AnyObject])
        dictionary.setValue(self.shop_id, forKey:"shop_id")
        dictionary.setValue(self.name, forKey:"name")
        dictionary.setValue(self.accesstoken, forKey:"accesstoken")
        dictionary.setValue(self.adminuser, forKey:"adminuser")
        dictionary.setValue(self.adminpass, forKey:"adminpass")
        dictionary.setValue(self.picture, forKey:"picture")
        dictionary.setValue(self.birthday, forKey:"birthday")
        dictionary.setValue(self.gender, forKey:"gender")
        dictionary.setValue(self.login_time, forKey:"login_time")
        dictionary.setValue(self.create_time, forKey:"create_time")
        dictionary.setValue(self.update_time, forKey:"update_time")
        dictionary.setValue(self.status, forKey:"status")
        dictionary.setValue(self.role, forKey:"role")
        
        dictionary.setValue(self.tel, forKey:"tel")
        dictionary.setValue(self.rate, forKey:"rate")
        dictionary.setValue(self.info, forKey:"info")
        dictionary.setValue(self.fee, forKey:"fee")
        dictionary.setValue(self.discount, forKey:"discount")
        dictionary.setValue(self.hours, forKey:"hours")
        dictionary.setValue(self.manager, forKey:"manager")
        dictionary.setValue(self.mobile, forKey:"mobile")
        dictionary.setValue(self.identification, forKey:"identification")
        dictionary.setValue(self.identification_picture, forKey:"identification_picture")
        dictionary.setValue(self.credential, forKey:"credential")
        dictionary.setValue(self.pass_time, forKey:"pass_time")
        dictionary.setValue(self.sort, forKey:"sort")
        
        return dictionary
    }
    
    
}