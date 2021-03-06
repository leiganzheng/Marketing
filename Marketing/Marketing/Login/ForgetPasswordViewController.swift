//
//  ForgetPasswordViewController.swift
//  QooccDoctor
//
//  Created by leiganzheng on 15/7/6.
//  Copyright (c) 2015年 leiganzheng. All rights reserved.
//  Modify by Leiganzheng 2015-7-13

import UIKit

/**
*  @author leiganzheng, 15-07-06
*
*  // MARK: - 忘记密码
*/
private let overTimeMax = 60
class ForgetPasswordViewController: UIViewController, QNInterceptorNavigationBarShowProtocol {

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    
    
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
                if !QNTool.stringCheck(strongSelf.textField1.text) {
                    QNTool.showPromptView("请填写手机号码")
                    strongSelf.textField1.text = nil; strongSelf.textField1.becomeFirstResponder()
                }
                else {
                    QNNetworkTool.fetchAuthCode("", type: "", flag: "", target: strongSelf.textField1.text!, completion: { (code, error, erroMsg) -> Void in
                        if code != nil {
                            QNTool.showPromptView("验证码已经发送到你手机,请注意查收")
                        }else{
                         QNTool.showPromptView(erroMsg)
                        }
                        
                    })
                }
            }
        }
        
        // 键盘消失
        let tap = UITapGestureRecognizer()
        tap.rac_gestureSignal().subscribeNext { [weak self](tap) -> Void in
            self?.view.endEditing(true)
        }
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 重置密码
    @IBAction func resetPassword(sender: UIButton!){
        if self.check() {
            QNNetworkTool.findPassWord("", type: "", account: self.textField1.text!, code: self.textField2.text!, new_password: self.textField3.text!, completion: { (succeed, error, errorMsg) -> Void in
                if succeed == true {
                    QNTool.showPromptView("密码修改成功，请登录")
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
                }
            })
        }
    }
    
    // 判断输入的合法性
    private func check() -> Bool {
        if !QNTool.stringCheck(self.textField1.text) {
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
            self.resetPassword(nil)
        }
        
        return true
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
