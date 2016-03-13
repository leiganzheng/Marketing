//
//  User.swift
//  Marketing
//
//  Created by leiganzheng on 16/1/14.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

/**
 *  用户账号信息
 *
 */
class User: QN_Base {
    private(set) var uid: String!          // Id
    private(set) var nickname: String?        // 名称
    private(set) var accesstoken: String!              // 登录状态校验令牌
    private(set) var adminuser: String? //（******占位符管理中心专属）
    private(set) var adminpass: String?
    
    private(set) var picture: String?
    private(set) var birthday: String?
    private(set) var gender: String?
    private(set) var login_time: String?
    private(set) var create_time: String?
    private(set) var update_time: String?
    private(set) var mobile: String?
    private(set) var status: String?
    private(set) var role: String?        // 身份（站长-1、商家-2、客户-3）
    
    required init!(_ dictionary: NSDictionary) {
        // 先判断存在性
        if !QN_Base.existValue(dictionary, keys: "uid") {
            super.init(dictionary)
            return nil
        }
        // 所需要的数据都存在，则开始真正的数据初始化
        self.uid = dictionary["uid"] as! String
        self.nickname = dictionary["nickname"] as? String
        if QN_Base.existValue(dictionary, keys: "accesstoken") {
            self.accesstoken = dictionary["accesstoken"] as! String
        }
        
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
        self.mobile = dictionary["mobile"] as? String
        super.init(dictionary)
    }
    
    override func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.addEntriesFromDictionary(super.dictionary() as [NSObject : AnyObject])
        dictionary.setValue(self.uid, forKey:"uid")
        dictionary.setValue(self.nickname, forKey:"nickname")
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
         dictionary.setValue(self.mobile, forKey:"mobile")
        return dictionary
    }
    
    
}

