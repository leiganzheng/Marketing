//
//  RegisterViewController.swift
//  QooccDoctor
//
//  Created by Leiganzheng on 15/7/7.
//  Copyright (c) 2015年 leiganzheng. All rights reserved.
//

import UIKit

/**
*  @author Leiganzheng, 15-07-07
*
*  // MARK: - 注册
*/

// MARK: - 获取验证码UI 显示的超时时间
private let overTimeMax = 60

class RegisterViewController: UIViewController, QNInterceptorNavigationBarHiddenProtocol, QNInterceptorKeyboardProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    var authCode: NSInteger!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RegisterViewController.configTextField(self.textField1)
        RegisterViewController.configTextField(self.textField2)
        RegisterViewController.configTextField(self.textField3)
        
        // 获取验证码的按钮
        let authCodeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90*COEFFICIENT_OF_WIDTH_ZOOM, height: self.textField2.bounds.height*COEFFICIENT_OF_HEIGHT_ZOOM))
        authCodeButton.layer.borderWidth = 0.5
        authCodeButton.layer.borderColor = defaultLineColor.CGColor
        authCodeButton.backgroundColor = appThemeColor
        authCodeButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        self.waitingAuthCode(authCodeButton, start: false)
        self.textField2.rightView = authCodeButton
        authCodeButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self](sender) -> Void in
            if let strongSelf = self {
               strongSelf.fetchAuthCode(strongSelf, phone: { () -> String? in
                    if !QNTool.stringCheck(strongSelf.textField1.text) {
                        QNTool.showPromptView("请填写手机号码")
                        strongSelf.textField1.text = nil; strongSelf.textField1.becomeFirstResponder()
                        return nil
                    }
                    else {
                        return strongSelf.textField1.text!
                    }
                }, authCodeButton: authCodeButton, isRegister: true)
            }
        }
        
        // 键盘消失
        let tap = UITapGestureRecognizer()
        tap.rac_gestureSignal().subscribeNext { [weak self](tap) -> Void in
            self?.view.endEditing(true)
        }
        self.view.addGestureRecognizer(tap)
    }

//     配置输入框，会在其他界面用到
    class func configTextField(textField: UITextField) {
        textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        textField.layer.cornerRadius = 2
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = defaultLineColor.CGColor
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .Always
        
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.rightViewMode = .Always
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // 提交
    @IBAction func done(sender: UIButton!) {
        if self.check() {
            QNTool.showActivityView("正在注册...", inView: self.view)
            QNNetworkTool.register(self.textField1.text!, password: self.textField3.text!, authcode: self.textField2.text!, completion: { (user, error, errorMsg) -> Void in
               QNTool.hiddenActivityView()
                if (user != nil) {
                    //进入主界面
                    g_user = user
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    QNTool.enterRootViewController(vc!, animated: true)
                }else {
                    QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
                }
            })
        }
    }
    
    // 判断输入的合法性
    private func check() -> Bool {
        if !QNTool.stringCheck(self.textField1.text, allowLength: 10) {
            QNTool.showPromptView("请填写手机号码")
            self.textField1.text = nil; self.textField1.becomeFirstResponder()
            return false
        }
        
        if !QNTool.stringCheck(self.textField2.text) {
            QNTool.showPromptView("请填写验证码")
            self.textField2.text = nil; self.textField2.becomeFirstResponder()
            return false
        }
        
        if !QNTool.stringCheck(self.textField3.text, allowAllSpace: true, allowLength: 5) {
            QNTool.showPromptView("请设置6位及以上的密码！")
            self.textField3.becomeFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.textField1 {
            self.textField2.becomeFirstResponder()
        }
        else if textField == self.textField2 {
            self.textField3.becomeFirstResponder()
        }
        else if textField == self.textField3 {
            textField.resignFirstResponder()
            self.done(nil)
        }
        
        return true
    }
    // MARK: 验证码
    // 从服务器获取验证码
     func fetchAuthCode(viewController: UIViewController, phone: (() -> String?), authCodeButton: UIButton?, isRegister: Bool){
        if let phoneNum = phone() where phoneNum.characters.count > 0 {
            QNNetworkTool.fetchAuthCode("3", type: "0",flag: "Register", target: phoneNum) { (code, error, errorMsg) -> Void in
                if (code != nil) {
                    self.waitingAuthCode(authCodeButton, start: true)
                    self.authCode = code as! NSInteger
                    self.textField2.text = "\(code)"
                }
                else {
                    QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
                }
            }
        }
    }
    
    
    // 显示获取验证码倒计时
     func waitingAuthCode(button: UIButton!, start: Bool = false) {
        if button == nil { return } // 验证码的UI变化，如果没有button，则不会有变化
        
        let overTimer = button.tag
        if overTimer == 0 && start {
            button.tag = overTimeMax
        }
        else {
            button.tag = max(overTimer - 1, 0)
        }
        
        if button.tag == 0 {
            button.setTitle("获取验证码", forState: .Normal)
            button.backgroundColor = appThemeColor
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
            button.enabled = true
        }
        else {
            button.setTitle("\(button.tag)S", forState: .Normal)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(appThemeColor, forState: .Normal)
            button.enabled = false
            button.setNeedsLayout()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(UInt64(1) * NSEC_PER_SEC)), dispatch_get_main_queue(), { () in
                self.waitingAuthCode(button)
            })
        }
    }

}


