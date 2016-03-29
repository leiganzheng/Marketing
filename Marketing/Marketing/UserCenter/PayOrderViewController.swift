//
//  PayOrderViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/29.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit
//import IPAdress.h

class PayOrderViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate,QNInterceptorProtocol {
    
    var titles: NSArray!
    var subTitles: NSArray!
    var icons: NSArray!
    var order: Order!
    @IBOutlet weak var customTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单支付"
        self.titles = ["微信支付","支付宝"]
        self.subTitles = ["微信安全支付","支付宝快捷支付"]
        self.icons = ["advisory_doctor_Pay_wechat","advisory_doctor_Pay_Alipay"]
        self.customTableView.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        customView.backgroundColor = defaultBackgroundGrayColor
        let lb = UILabel(frame: CGRectMake(8,5,200, 30))
        lb.backgroundColor = UIColor.clearColor()
        lb.textColor = tableViewCellDefaultTextColor
        lb.textAlignment = NSTextAlignment.Left
        lb.font = UIFont.systemFontOfSize(13)
        lb.text = "请支付"
        customView.addSubview(lb)
        
        let lb1 = UILabel(frame: CGRectMake(tableView.frame.size.width-110,5,100, 30))
        lb1.backgroundColor = UIColor.clearColor()
        lb1.textColor = tableViewCellDefaultTextColor
        lb1.textAlignment = NSTextAlignment.Right
        lb1.font = UIFont.systemFontOfSize(13)
        lb1.text = "¥200元"
        customView.addSubview(lb1)
        
        return customView
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell1"
        var cell: UITableViewCell! = self.customTableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            cell.accessoryType = .DisclosureIndicator
        }
        cell.textLabel?.text = self.titles[indexPath.row] as? String
        cell.imageView?.image = UIImage(named: (icons[indexPath.row] as? String)!)
        cell.detailTextLabel?.text = self.subTitles[indexPath.row] as? String
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            self.wxPayCheck()
        }else{
            self.aliPayCheck()
        }
    }
    //微信支付
    private func wxPayCheck(){
        
//        if WXApi.isWXAppInstalled() {
            QNNetworkTool.weChatPay("测试微信", out_trade_no: self.order.order_id!, spbill_create_ip: ip_names[0], completion: { (dictionary, error, errorMsg) -> Void in
                if dictionary != nil {
                    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    delegate.submitOrder(dictionary!, vc: self)
                }else {
                    QNTool.showPromptView( errorMsg!)
                }

            })
//        }else{
//            QNTool.showPromptView( "请安装微信客户端")
//        }
    }
    //支付宝支付
    private func aliPayCheck(){
        let sign = "MIIEowIBAAKCAQEA0XNv9r11PUQ+5VBvioK98LWqJrpLtZ7Go22ltiACffn+S215" +
        "5NjBmKtJXMjE8xHvY6PQXTsC7nZeIa1VHXvw+KkeV0BJCXeTUzhz3MzcTfsNfvtr" +
        "rQeNSLNVPQ59sNiKLxO3Hsr3ldbTNNrkcgwPVRx1S76rT+huX5RTm1dKkZrCifEq" +
        "OaJwNYzZPEivksDdEUgZPsRp46n0BSWeFfO3qNSoqpjEuM5gK0GZzpwJbWAQDc7y" +
        "SqJ3/Dm1fzG5S/2fxF69uG2d3u08+LhrHAjW9OJrLcksI+ApWwbDNUEOI5JBx05/" +
        "JmYgmWVyKXmh2T46hJ/KCFz/vgELJ7XgKF8XOwIDAQABAoIBAEZ59V6s+VoYMKGw" +
        "oxeUTp1EQ3CslvUR6/zp1CyoMK57BBoVSEK8vMfGOvVBiSPRESAR6vaz+JSMt7fV" +
        "PyKgpcDGBzOMqgbJeYUzJalSNX73zt6/csfSFrQzw6a7zYdIFZcppyBxY0XD92V9" +
        "kgjeDfqxjLZj/fjxWNJIcql+gdTkBivkGqB0LbA4TGEaoNC51hBt8Bzy+hH4HaMe" +
        "WAtTR1b8nenjDac79uNhCxhLR7H2YWIbMUOjkcHJPErtuB4lgj7ObGAAIQnw3ml6" +
        "NP16J6qqsooN7Ac04E/VBw1TrnYIea0OmtXKxc5yCUvoPOrTMqo4oTg0EY5a3hGt" +
        "w3QMuYECgYEA9Di6XjtiDs9ZAMvq5h5wIhOW1EhXUBRFdwKf09czp9dBChRM8l7d" +
        "L3bCKDCp0RpOnciNGcU6mvfEF/ZJirffU8sGk2NjENES125UYh/L2IKFHyyJH4Ln" +
        "c/PuUsG4uUU23xEbzuB7+ABOVoUJhdNCxl3CupNitFz5ieDgLG/y1PECgYEA241q" +
        "LAQF/GWfSmwbFT6yoYSWkAP+93uwpb4rY7IauELVdHDbl4mFHBhhviCilTpXG4Xj" +
        "lrBZW/T2K/N//ca24ULYJtJFvpO0gEKj8sru9/uN8o+d3ye3qGR6wa+6WGC23gby" +
        "SJPcjr4ODlbTeOfYGU6e47Rwu0LLdW3jnp4XfusCgYB7ef8IS7/dOwqF85PVO0h4" +
        "giz9MYIrs8QXUtVaNvEgCB4TKYZp+HqeV838ofYKCeH7tn1YrTZfSav0bYprP2ID" +
        "rJ+rf1GEHCEJmPfDEM5wrjT+OPcvXnEFWCyD3Pw3d/4xNCY6J5emIQl6hxL0fYbC" +
        "Yn9k88Ww6V0lT/Qno4ZEEQKBgQDG+6r/S4I1V9D/vWzqW1HAi4995PE/Ua4u+WUP" +
        "zUrkN0aIawTKmcu3Q+3KSH+x6hcqjbVQTHIgoqo9+UnGMkRrco6+2JJ3gBz2pe87" +
        "TGs6+5WSAlHd/3w3tSGAy4iDMtxp7DfISaJ7CItquYyeJto3TYc57r7BKW+G9Vp3" +
        "1uaKkwKBgEM2MlDH1CF0V3Mbvm7wNwMGDjFiQCAb8WK3TUHl1kmFwdgc1mAsCdWO" +
        "ZZvqIGlo/IUDrnHr9Hr1zG1B8jidLzTkQEyWdqTlQWlU+RTWzrv/bs8I/C5L83Z0" +
        "OATH6/sqzxrCkIwoD3UDmkeUhCKU7pvCf/6CzJxXlpq0n3Nt5W3e"
        
        let orderString = String(format: "partner=\"%@\"&seller_id=\"%@\"&out_trade_no=\"%@\"&subject=\"%@\"&body=\"\"%@&total_fee=\"%@\"&notify_url=\"%@\"&service=\"%@\"&payment_type=\"%@\"&_input_charset=\"%@\"&it_b_pay=\"%@\"&sign=\"%@\"&sign_type=\"%@\"", "2088121819111753" ,"2564064860@qq.com",self.order.order_id!,"测试","测试测试",self.order.order_price!,"http://cvsapi.1g9f.com/Alipayapi/AliPayNotify","mobile.securitypay.pay","1","utf-8","30m",sign,"RSA")
        print(orderString)
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        let appScheme: String = "alipayForMarket"
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: { (resultDic) -> Void in
            if let Alipayjson = resultDic as? NSDictionary {
                let resultStatus = Alipayjson.valueForKey("resultStatus") as! String
                if resultStatus == "9000"{
                    QNTool.showPromptView( "支付成功")
                }else if resultStatus == "8000" {
                    QNTool.showPromptView( "正在处理中")
                }else if resultStatus == "4000" {
                    QNTool.showPromptView( "订单支付失败")
                }else if resultStatus == "6001" {
                    QNTool.showPromptView( "用户中途取消")
                }else if resultStatus == "6002" {
                    QNTool.showPromptView( "网络连接出错")
                }
            }
        })
    }


}

