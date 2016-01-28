//
//  AdModel.swift
//  Marketing
//
//  Created by leiganzheng on 16/1/28.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import Foundation

class AdModel: QN_Base {
    
    private(set) var id: String!          // Id
    private(set) var position_id: String?        // 名称
    private(set) var title: String?
    private(set) var content: String?
    private(set) var picture: String?
    private(set) var url: String?
    
    private(set) var start_time: String?
    private(set) var end_time: String?
    private(set) var sort: String?
    private(set) var status: String?
    
    
    required init!(_ dictionary: NSDictionary) {
        // 先判断存在性
        if !QN_Base.existValue(dictionary, keys: "id") {
            super.init(dictionary)
            return nil
        }
        // 所需要的数据都存在，则开始真正的数据初始化
        self.id = dictionary["id"] as! String
        self.position_id = dictionary["position_id"] as? String
        self.title = dictionary["title"] as? String
        self.content = dictionary["content"] as? String
        self.picture = dictionary["picture"] as? String
        self.url = dictionary["url"] as? String
        
        self.start_time = dictionary["start_time"] as? String
        self.end_time = dictionary["end_time"] as? String
        self.sort = dictionary["sort"] as? String
        self.status = dictionary["status"] as? String
        super.init(dictionary)
    }
    
    override func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.addEntriesFromDictionary(super.dictionary() as [NSObject : AnyObject])
        dictionary.setValue(self.id, forKey:"id")
        dictionary.setValue(self.position_id, forKey:"position_id")
        dictionary.setValue(self.title, forKey:"title")
        dictionary.setValue(self.content, forKey:"content")
        dictionary.setValue(self.picture, forKey:"picture")
        dictionary.setValue(self.url, forKey:"url")
        
        dictionary.setValue(self.start_time, forKey:"start_time")
        dictionary.setValue(self.end_time, forKey:"end_time")
        dictionary.setValue(self.sort, forKey:"sort")
        dictionary.setValue(self.status, forKey:"status")
        

        return dictionary
    }
    
}

