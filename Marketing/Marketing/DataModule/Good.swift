//
//  Good.swift
//  Marketing
//
//  Created by leiganzheng on 16/1/28.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import Foundation

class Good: QN_Base {
    private(set) var good_id: String!
    private(set) var shop_id: String?
    private(set) var cat_id: String?
    private(set) var shop_cat_id: String?
    private(set) var name: String?
    private(set) var picture: String?
    private(set) var big_pic: String?
    private(set) var descriptionStr: String?
    private(set) var price: String?
    private(set) var discounted_price: String?
    private(set) var buy_num: String?
    private(set) var fav_num: String?
    private(set) var promotion_type: String?
    private(set) var storage: String?
    private(set) var verify: String?
    private(set) var rate: String?
    private(set) var sort: String?
    private(set) var create_time: String?
    private(set) var update_time: String?
    private(set) var status: String?
    
    required init!(_ dictionary: NSDictionary) {
        // 先判断存在性
        if !QN_Base.existValue(dictionary, keys: "good_id") {
            super.init(dictionary)
            return nil
        }
        // 所需要的数据都存在，则开始真正的数据初始化
        self.cat_id = dictionary["cat_id"] as? String
        self.good_id = dictionary["good_id"] as? String
        self.shop_id = dictionary["shop_id"] as? String
        self.shop_cat_id = dictionary["shop_cat_id"] as? String
        self.name = dictionary["name"] as? String
        self.picture = dictionary["picture"] as? String
        self.big_pic = dictionary["big_pic"] as? String
        self.price = dictionary["price"] as? String
        self.descriptionStr = dictionary["descriptionStr"] as? String
        self.discounted_price = dictionary["discounted_price"] as? String
        self.buy_num = dictionary["buy_num"] as? String
        self.fav_num = dictionary["fav_num"] as? String
        self.promotion_type = dictionary["promotion_type"] as? String
        self.storage = dictionary["storage"] as? String
        self.verify = dictionary["verify"] as? String
        self.rate = dictionary["rate"] as? String
        self.sort = dictionary["sort"] as? String
        self.create_time = dictionary["create_time"] as? String
        self.create_time = dictionary["update_time"] as? String
        self.status = dictionary["status"] as? String
        
        super.init(dictionary)
    }
    
    override func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.addEntriesFromDictionary(super.dictionary() as [NSObject : AnyObject])
        dictionary.setValue(self.cat_id, forKey:"cat_id")
        dictionary.setValue(self.good_id, forKey:"good_id")
        dictionary.setValue(self.shop_id, forKey:"shop_id")
        dictionary.setValue(self.shop_cat_id, forKey:"shop_cat_id")
        dictionary.setValue(self.name, forKey:"name")
        dictionary.setValue(self.picture, forKey:"picture")
        dictionary.setValue(self.big_pic, forKey:"big_pic")
        dictionary.setValue(self.descriptionStr, forKey:"descriptionStr")
        dictionary.setValue(self.price, forKey:"price")
        dictionary.setValue(self.discounted_price, forKey:"discounted_price")
        dictionary.setValue(self.buy_num, forKey:"buy_num")
        dictionary.setValue(self.fav_num, forKey:"fav_num")
        dictionary.setValue(self.promotion_type, forKey:"promotion_type")
        dictionary.setValue(self.storage, forKey:"storage")
        dictionary.setValue(self.verify, forKey:"verify")
        dictionary.setValue(self.sort, forKey:"sort")
        dictionary.setValue(self.rate, forKey:"rate")
        dictionary.setValue(self.create_time, forKey:"create_time")
        dictionary.setValue(self.create_time, forKey:"create_time")
        dictionary.setValue(self.status, forKey:"status")
        
        return dictionary
    }
    
}
