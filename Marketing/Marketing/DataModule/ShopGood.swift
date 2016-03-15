//
//  ShopGood.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/15.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class ShopGood: Good {
    private(set) var good_info: String!
    private(set) var shop_name: String?
    required init!(_ dictionary: NSDictionary) {
        self.good_info = dictionary["good_info"] as? String
        self.shop_name = dictionary["shop_name"] as? String
        
        super.init(dictionary)
    }
    
    override func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.addEntriesFromDictionary(super.dictionary() as [NSObject : AnyObject])
        dictionary.setValue(self.good_info, forKey:"good_info")
        dictionary.setValue(self.shop_name, forKey:"shop_name")
        return dictionary
    }

}
