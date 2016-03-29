//
//  AppDelegate.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/28.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,WXApiDelegate{

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // 开启拦截器
        QNInterceptor.start()
        //微信注册
        // 修改导航栏样式
        UINavigationBar.appearance().barTintColor = appThemeColor
        UINavigationBar.appearance().tintColor = appThemeColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(18)]
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let str = url.absoluteString
        if  str.hasPrefix("wx") {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        return false
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        AlipaySDK.defaultService().processOrderWithPaymentResult(url) { (resultDic) -> Void in
            print("reslut = \(resultDic)")
        }
        let str = url.absoluteString
        if str.hasPrefix("wx") {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        return false
    }

    func submitOrder(dic: NSDictionary, vc: UIViewController){

        WXApi.registerApp("wx34eb3f707f547551", withDescription: "Test")
        let request = PayReq()
        request.partnerId = dic["partnerId"] as! String
        request.openID = dic["appId"] as! String
        request.prepayId = dic["prepayId"] as! String
        request.package = dic["package"] as! String
        request.nonceStr = dic["nonceStr"] as! String
        request.timeStamp = dic["timeStamp"]!.unsignedIntValue
        request.sign = dic["sign"] as! String
        WXApi.sendReq(request)
    }

    //MARK:- WXApiDelegate
    func onResp(resp: BaseResp!) {
        if resp is PayResp{
            let response = resp as! PayResp
            switch(response.errCode){
            case 0:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                 QNTool.showPromptView("支付成功")
                break
            case -2:
                QNTool.showPromptView("支付取消")
                break
            case -3:
                QNTool.showPromptView( "发送失败")
                break
            case -4:
                QNTool.showPromptView( "授权失败")
                break
            case -5:
                QNTool.showPromptView( "微信不支持")
                break
            default:
                QNTool.showPromptView( "支付失败，retcode=\(resp.errCode)")
                break
            }
        }
    }


}

