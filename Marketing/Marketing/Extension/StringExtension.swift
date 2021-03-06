//
//  StringExtension.swift
//  
//
//  Created by Leiganzheng on 15/4/17.
//  Copyright (c) 2015年 Leiganzheng. All rights reserved.
//

import Foundation

extension String{
//    func sizeWithFont(font:UIFont, maxWidth:CGFloat) -> CGSize{
//        let attributedString = NSAttributedString(string: self, attributes: [NSFontAttributeName : font])
//        let rect = attributedString.boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
//        return rect.size
//    }
    
//    func sizeWithFont(font:UIFont, maxWidth:CGFloat, lines:Int) -> CGSize{
//        var size = self.sizeWithFont(font, maxWidth: maxWidth)
//        let simple = "a你".sizeWithAttributes([NSFontAttributeName : font])
//        size.height = min(simple.height * CGFloat(lines), size.height)
//        return size
//    }
    
    // MARK: 判断手机号码
    func checkStingIsPhone() -> Bool {
        // 手机号码
        let phoneRegex = "^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let phoneIsMatch = phonePred.evaluateWithObject(self)
        // 固定电话大陆
        let telRegex = "^0\\d{2,3}(\\-)?\\d{7,8}$"
        let telPred = NSPredicate(format: "SELF MATCHES %@", telRegex)
        let telIsMatch = telPred.evaluateWithObject(self)
        
        return (phoneIsMatch || telIsMatch)
    }
    
    //
    func checkStingIsNumber(count : Int) -> Bool {
        let regex = "^\\d{\(count)}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(self)
    }
    // MARK: 判断包含中文跟字母
    func checkStingIsName() -> Bool {
        let regex = "^[a-zA-Z\\u4e00-\\u9fa5]{1,8}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(self)
    }
    func MD5() ->String!{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        return String(format: hash as String)
    }
}