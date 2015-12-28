//
//  QNTool.swift
//  QooccHealth
//
//  Created by LiuYu on 15/5/28.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import Foundation
import UIKit
private let qnToolInstance = QNTool()

/**
 *  //MARK:- 通用工具类
 */
class QNTool: NSObject {
    
}
/**
 *  @author LiuYu, 15-05-28 16:05:14
 *
 *  //MARK:- 页面切换相关
 */
extension QNTool {
    
    /**
     //MARK: 转场动画过渡
     
     :param: vc 将要打开的ViewController
     */
    class func enterRootViewController(vc: UIViewController, animated: Bool = true) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let animationView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
            appDelegate.window?.addSubview(animationView)
            let changeRootViewController = { () -> Void in
                appDelegate.window?.rootViewController = vc
                if animated {
                    appDelegate.window?.bringSubviewToFront(animationView)
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        animationView.transform = CGAffineTransformMakeScale(3.0, 3.0)
                        animationView.alpha = 0
                        }, completion: { (finished) -> Void in
                            animationView.removeFromSuperview()
                    })
                }
                else {
                    animationView.removeFromSuperview()
                }
            }
            
            if let viewController = appDelegate.window?.rootViewController where viewController.presentedViewController != nil {
                viewController.dismissViewControllerAnimated(false) {
                    changeRootViewController()
                }
            }
            else {
                changeRootViewController()
            }
        }
    }
    
    /**
     //MARK: 进入登陆的控制器
     */
    class func enterLoginViewController() {
        let vc = (UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!)
        QNTool.enterRootViewController(vc)
    }
}

// MARK: - 让 Navigation 支持右滑返回
extension QNTool: UIGestureRecognizerDelegate {
    
    /**
     让 Navigation 支持右滑返回
     
     :param: navigationController 需要支持的 UINavigationController 对象
     */
    class func addInteractive(navigationController: UINavigationController?) {
        navigationController?.interactivePopGestureRecognizer!.enabled = true
        navigationController?.interactivePopGestureRecognizer!.delegate = qnToolInstance
    }
    
    /**
     移除 Navigation 右滑返回
     
     :param: navigationController 需要支持的 UINavigationController 对象
     */
    class func removeInteractive(navigationController: UINavigationController?) {
        navigationController?.interactivePopGestureRecognizer!.enabled = false
        navigationController?.interactivePopGestureRecognizer!.delegate = nil
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        _ = topViewController()
        if let vc = topViewController() where gestureRecognizer == vc.navigationController?.interactivePopGestureRecognizer {
            return (vc.navigationController!.viewControllers.count > 1)
        }
        return false // 其他情况，则不支持
    }
    
    
}
// MARK: - 检查字符串的合法性
extension QNTool {
    /**
     检查字符串的合法性
     
     :param: string      源字符串
     :param: allowSpace  是否允许全空格
     :param: allowLength 合法字符串必须大于的长度
     */
    class func stringCheck(string: String?, allowAllSpace: Bool = false, allowLength: Int = 0) -> Bool {
        if let text = string where (allowAllSpace ? text : text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions(), range: nil)).characters.count > allowLength {
            return true
        }
        return false
    }
}
