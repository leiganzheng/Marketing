//
//  Address.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/1.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import Foundation

class Address: QN_Base {
    private(set) var id: String!          // Id
    private(set) var uid: String?        // 名称
    private(set) var longitude: String?
    private(set) var latitude: String?
    private(set) var mobile: String?
    private(set) var address: String?
    private(set) var address_detail: String?
    private(set) var update_time: String?
    private(set) var status: String?
    
    required init!(_ dictionary: NSDictionary) {
        // 先判断存在性
        if !QN_Base.existValue(dictionary, keys: "id") {
            super.init(dictionary)
            return nil
        }
        // 所需要的数据都存在，则开始真正的数据初始化
        self.id = dictionary["id"] as! String
        self.uid = dictionary["uid"] as? String
        self.longitude = dictionary["longitude"] as? String
        self.latitude = dictionary["latitude"] as? String
        self.mobile = dictionary["mobile"] as? String
        self.address = dictionary["address"] as? String
        self.address_detail = dictionary["address_detail"] as? String
        self.update_time = dictionary["update_time"] as? String
         self.status = dictionary["status"] as? String
        super.init(dictionary)
    }
    
    override func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.addEntriesFromDictionary(super.dictionary() as [NSObject : AnyObject])
        dictionary.setValue(self.id, forKey:"id")
        dictionary.setValue(self.uid, forKey:"uid")
        dictionary.setValue(self.longitude, forKey:"longitude")
        dictionary.setValue(self.latitude, forKey:"latitude")
        dictionary.setValue(self.mobile, forKey:"mobile")
        dictionary.setValue(self.address, forKey:"address")
        dictionary.setValue(self.address_detail, forKey:"address_detail")
        dictionary.setValue(self.update_time, forKey:"update_time")
        dictionary.setValue(self.status, forKey:"status")
        
        return dictionary
    }

}
