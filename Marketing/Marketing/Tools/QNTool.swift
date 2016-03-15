//
//  QNTool.swift
//  QooccHealth
//
//  Created by Leiganzheng on 15/5/28.
//  Copyright (c) 2015年 Leiganzheng. All rights reserved.
//

import Foundation
import UIKit

private let qnToolInstance = QNTool()

/**
 *  //MARK:- 通用工具类
 */
class QNTool: NSObject {
    
}
// MARK: - 提示框相关
extension QNTool {
    
    /**
     弹出会自动消失的提示框
     
     :param: message    提示内容
     :param: completion 提示框消失后的回调
     */
    class func showPromptView(message: String = "服务升级中，请耐心等待！", _ completion: (()->Void)? = nil) {
        lyShowPromptView(message, completion)
    }
    
    /**
     弹出进度提示框
     
     :param: message         提示内容
     :param: inView          容器，如果设置为nil，会放在keyWindow上
     :param: timeoutInterval 超时隐藏，如果设置为nil，超时时间是3min
     */
    class func showActivityView(message: String?, inView: UIView? = nil, _ timeoutInterval: NSTimeInterval? = nil) {
        lyShowActivityView(message, inView: inView, timeoutInterval)
    }
    
    /**
     隐藏进度提示框
     */
    class func hiddenActivityView() {
        lyHiddenActivityView()
    }
    
    /**
     显示错误提示
     
     优先显示服务器返回的错误信息，如果没有，则显示网络层返回的错误信息，如果在没有，则显示默认的错误提示
     
     :param: dictionary 服务器返回的Dic
     :param: error      网络层返回的error
     :param: errorMsg   服务器返回的错误信息
     */
    class func showErrorPromptView(dictionary: NSDictionary?, error: NSError?, errorMsg: String? = nil) {
        if errorMsg != nil {
            QNTool.showPromptView(errorMsg!); return
        }
        
        if let errorMsg = dictionary?["errorMsg"] as? String {
            QNTool.showPromptView(errorMsg); return
        }
        
        if error != nil && error!.domain.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            QNTool.showPromptView("网络异常，请稍后重试！"); return
        }
        
        QNTool.showPromptView()
    }
    
    
}

// MARK: - 增加空提示的View
private let kTagEmptyView = 96211
private let kTagMessageLabel = 96212
extension QNTool {
    
    /**
     为inView增加空提示
     
     :param: message    提示内容
     :param: inView     所依附的View
     */
    class func showEmptyView(message: String? = nil, inView: UIView?) {
        if inView == nil { return }
        
        //
        var emptyView: UIView! = inView!.viewWithTag(kTagEmptyView)
        if emptyView == nil {
            emptyView = UIView(frame: inView!.bounds)
            emptyView.backgroundColor = UIColor.clearColor()
            emptyView.tag = kTagEmptyView
            inView!.addSubview(emptyView)
        }
        
        // 设置提示
        if message != nil {
            let widthMax = emptyView.bounds.width - 40
            var messageLabel: UILabel! = emptyView.viewWithTag(kTagMessageLabel) as? UILabel
            if messageLabel == nil {
                messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: widthMax, height: 20))
                messageLabel.tag = kTagMessageLabel
                messageLabel.textColor = tableViewCellDefaultDetailTextColor
                messageLabel.backgroundColor = UIColor.clearColor()
                messageLabel.textAlignment = .Center
                messageLabel.autoresizingMask = .FlexibleWidth
                messageLabel.numberOfLines = 0
                emptyView.addSubview(messageLabel)
            }
            
            messageLabel.text = message
            messageLabel.bounds = CGRect(origin: CGPointZero, size: messageLabel.sizeThatFits(CGSize(width: widthMax, height: CGFloat.max)))
            messageLabel.center = CGPoint(x: emptyView.bounds.width/2.0, y: emptyView.bounds.height/2.0)
        }
        else {
            emptyView.viewWithTag(kTagMessageLabel)?.removeFromSuperview()
        }
    }
    
    /**
     隐藏空提示
     
     :param: inView     所依附的View
     */
    class func hiddenEmptyView(forView: UIView?) {
        forView?.viewWithTag(kTagEmptyView)?.removeFromSuperview()
    }
    
    
}

/**
 *  @author Leiganzheng, 15-05-28 16:05:14
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
    // 电话按钮被
   class func tel(mobile: String) {
    if mobile.characters.count>0 {
            let phoneUrl = NSURL(string: "tel://" + mobile)
            let iphoneAlertView = UIAlertView(title: "确认要拨打" + mobile + "的电话吗？", message: "电话：" + mobile, delegate: nil, cancelButtonTitle: "取消")
            iphoneAlertView.addButtonWithTitle("确认")
            iphoneAlertView.rac_buttonClickedSignal().subscribeNext({(indexNumber) -> Void in
                if indexNumber as? Int != 0 {
                    if !UIApplication.sharedApplication().openURL(phoneUrl!) {
                        let alert = UIAlertView(title: "", message: "无法打开程序", delegate: nil, cancelButtonTitle: "确认")
                        alert.show()
                    }
                }
            })
            
            iphoneAlertView.show()
            return
        }
        QNTool.showPromptView("暂没有提供电话号码")
    }

}
