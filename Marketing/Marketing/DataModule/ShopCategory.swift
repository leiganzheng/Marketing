//
//  ShopCategory.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/1.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import Foundation

class ShopCategory: QN_Base {
    private(set) var shop_cat_id: String!          // Id
    private(set) var name: String?        // 名称
    private(set) var picture: String?
    private(set) var descriptionStr: String?
    private(set) var parent: String?
    private(set) var sort: String?
    
    required init!(_ dictionary: NSDictionary) {
        // 先判断存在性
        if !QN_Base.existValue(dictionary, keys: "shop_cat_id") {
            super.init(dictionary)
            return nil
        }
        // 所需要的数据都存在，则开始真正的数据初始化
        self.shop_cat_id = dictionary["shop_cat_id"] as! String
        self.name = dictionary["name"] as? String
        self.picture = dictionary["picture"] as? String
        self.descriptionStr = dictionary["description"] as? String
        self.parent = dictionary["parent"] as? String
        self.sort = dictionary["sort"] as? String
        super.init(dictionary)
    }
    
    override func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.addEntriesFromDictionary(super.dictionary() as [NSObject : AnyObject])
        dictionary.setValue(self.shop_cat_id, forKey:"shop_cat_id")
        dictionary.setValue(self.name, forKey:"name")
        dictionary.setValue(self.picture, forKey:"picture")
        dictionary.setValue(self.descriptionStr, forKey:"description")
        dictionary.setValue(self.parent, forKey:"parent")
        dictionary.setValue(self.sort, forKey:"sort")
        
        return dictionary
    }
    
}

