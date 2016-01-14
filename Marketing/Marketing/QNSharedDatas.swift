//
//  QNSharedDatas.swift
//  QooccShow
//
//  Created by Leiganzheng on 14/10/31.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

/*!
 *  此文件中放置整个App共享的数据
 */
import UIKit
import OpenUDID

//MARK:- 账号 & 账号管理
//MARK: 账号（登录成功的）

//////MARK:- 加密解密密钥
////let g_SecretKey = "qoocc"
////private let kKeyAccount = ("Account" as NSString).encrypt(g_SecretKey)
//var g_Account: String? {
//    return (getObjectFromUserDefaults(kKeyAccount) as? NSString)?.decrypt(g_SecretKey)
//}
////MARK: 密码（登录成功的）
//private let kKeyPassword = ("Password" as NSString).encrypt(g_SecretKey)
//var g_Password: String? {
//    return (getObjectFromUserDefaults(kKeyPassword) as? NSString)?.decrypt(g_SecretKey)
//}
////MARK: 保存账号和密码
//func saveAccountAndPassword(account: String, password: String?) {
//    saveObjectToUserDefaults(kKeyAccount, value: (account as NSString).encrypt(g_SecretKey))
//    if password == nil {
//        cleanPassword()
//    }
//    else {
//        saveObjectToUserDefaults(kKeyPassword, value: (password! as NSString).encrypt(g_SecretKey))
//    }
//}
////MARK: 清除密码
//func cleanPassword() {
//    removeObjectAtUserDefaults(kKeyPassword)
//}
//
//MARK: 当前账户信息有变更时的通知
//var g_isLogin: Bool { return g_doctor != nil }    // 是否登录
//MARK: g_doctor 当登录账号
var g_user: User?



//MARK:- UDID
private var _udid: String?
var g_UDID: String {
    if _udid == nil {
        var udid = OpenUDID.value() as NSString
        if udid.length > 32 {
            udid = udid.substringToIndex(32)
        }
        _udid = udid as String
    }
    return _udid!
}






