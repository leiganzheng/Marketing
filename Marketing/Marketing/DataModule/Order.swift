//
//  Order.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/1.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import Foundation

class Order: QN_Base {
    private(set) var order_id: String!
    private(set) var shop_id: String?
    private(set) var uid: String?
    private(set) var payment_id: String?
    private(set) var pay_sn: String?
    private(set) var pay_time: String?
    private(set) var finish_time: String?
    private(set) var evaluation_status: String?
    private(set) var goods_price: String?
    private(set) var order_price: String?
    private(set) var refund_amount: String?
    private(set) var shipping_code: String?
    private(set) var customer_address_id: String?
    private(set) var create_time: String?
    private(set) var update_time: String?
    private(set) var status: String?
    var goods=[Good]()
    
    required init!(_ dictionary: NSDictionary) {
        // 先判断存在性
        if !QN_Base.existValue(dictionary, keys: "order_id") {
            super.init(dictionary)
            return nil
        }
        // 所需要的数据都存在，则开始真正的数据初始化
        self.uid = dictionary["uid"] as? String
        self.order_id = dictionary["order_id"] as? String
        self.shop_id = dictionary["shop_id"] as? String
        self.payment_id = dictionary["payment_id"] as? String
        self.pay_sn = dictionary["pay_sn"] as? String
        self.pay_time = dictionary["pay_time"] as? String
        self.finish_time = dictionary["finish_time"] as? String
        self.goods_price = dictionary["goods_price"] as? String
        self.evaluation_status = dictionary["evaluation_status"] as? String
        self.order_price = dictionary["order_price"] as? String
        self.refund_amount = dictionary["refund_amount"] as? String
        self.shipping_code = dictionary["shipping_code"] as? String
        self.customer_address_id = dictionary["customer_address_id"] as? String
        self.create_time = dictionary["create_time"] as? String
        self.create_time = dictionary["update_time"] as? String
        self.status = dictionary["status"] as? String
//        for goodsDictionary in dictionary["order_goods"] as! NSArray {
//            if let dictionary = goodsDictionary as? NSDictionary, let good = Good(dictionary) {
//                self.goods.append(good)
//            }
//        }
        super.init(dictionary)
    }
    
    override func dictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.addEntriesFromDictionary(super.dictionary() as [NSObject : AnyObject])
        dictionary.setValue(self.uid, forKey:"uid")
        dictionary.setValue(self.order_id, forKey:"order_id")
        dictionary.setValue(self.shop_id, forKey:"shop_id")
        dictionary.setValue(self.payment_id, forKey:"payment_id")
        dictionary.setValue(self.pay_sn, forKey:"pay_sn")
        dictionary.setValue(self.pay_time, forKey:"pay_time")
        dictionary.setValue(self.finish_time, forKey:"finish_time")
        dictionary.setValue(self.evaluation_status, forKey:"evaluation_status")
        dictionary.setValue(self.goods_price, forKey:"goods_price")
        dictionary.setValue(self.order_price, forKey:"order_price")
        dictionary.setValue(self.refund_amount, forKey:"refund_amount")
        dictionary.setValue(self.shipping_code, forKey:"shipping_code")
        dictionary.setValue(self.customer_address_id, forKey:"customer_address_id")
        dictionary.setValue(self.create_time, forKey:"create_time")
        dictionary.setValue(self.create_time, forKey:"create_time")
        dictionary.setValue(self.status, forKey:"status")
//        let goods = NSMutableArray()
//        for good in self.goods {
//            goods.addObject(good.dictionary())
//        }
//        dictionary.setValue(goods, forKey: "order_goods")
        return dictionary
    }

}
