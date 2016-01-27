
//  LoginViewController.swift
//  QooccHealth
//
//  Created by Leiganzheng on 15/4/13.
//  Copyright (c) 2015年 Leiganzheng. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SDWebImage
/**
*  @author Leiganzheng, 15-05-15 10:05:27
*
*  //MARK:- 用户登录
*/
class LoginViewController: UIViewController, QNInterceptorNavigationBarHiddenProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.translucent = false // 关闭透明度效果
        // 让导航栏支持向右滑动手势
        QNTool.addInteractive(self.navigationController)
        
        self.imageView.image = UIImage(named: "Login_Logo.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.imageView.tintColor = appThemeColor
        self.imageView.tintAdjustmentMode = .Normal
        let picStr = getObjectFromUserDefaults("UserPic") as? String
        if picStr != nil {
            self.imageView.sd_setImageWithURL(NSURL(string:picStr!), placeholderImage: nil)
        }
        QNTool.configViewLayer(self.imageView)
        
        RegisterViewController.configTextField(self.accountTextField)
        self.accountTextField.text = g_Account
        let accountImageView = UIImageView(frame: CGRectMake(4, 0, 40, 20))
        accountImageView.contentMode = UIViewContentMode.Center
//        accountImageView.image = UIImage(named: "Login_Account")
//        self.accountTextField.leftView = accountImageView
        
        RegisterViewController.configTextField(self.passwordTextField)
        self.passwordTextField.secureTextEntry = true
        let passwordImageView = UIImageView(frame: CGRectMake(4, 0, 40, 20))
        passwordImageView.contentMode = UIViewContentMode.Center
//        passwordImageView.image = UIImage(named: "Login_Password")
//        self.passwordTextField.leftView = passwordImageView

        // 键盘消失
        let tap = UITapGestureRecognizer()
        tap.rac_gestureSignal().subscribeNext { [weak self](tap) -> Void in
            self?.view.endEditing(true)
        }
        self.view.addGestureRecognizer(tap)
        // 如果有本地账号了，就自动登录
        self.autoLogin()
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.returnKeyType == .Next {
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField.returnKeyType == .Done {
            self.login()
        }
        return false
    }
    
    // MARK: 登录
    @IBAction func login(sender: AnyObject) {
        self.login()
    }
    
    func login() {
        if !self.checkAccountPassWord() {return}
        if let id = self.accountTextField.text, let password = self.passwordTextField.text {
            QNTool.showActivityView("正在登录...")
            QNNetworkTool.login(Account: id, Password: password, Role: "3", completion: { (user, error, errorMsg) -> Void in
                 QNTool.hiddenActivityView()
                if user != nil {
                    //进入主界面
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    QNTool.enterRootViewController(vc!, animated: true)
                }else {
                    QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
                }
            })
        }
    }
    
    // MARK: 登录，并把accoutn和password写入的页面上
    func login(account: String, password: String) {
        self.accountTextField.text = account
        self.passwordTextField.text = password
        self.login()
    }
    
    // MARK: 自动登录，获取本机保存的账号密码进行登录
    func autoLogin() {
//        if let account = g_Account, password = g_Password {
//            self.login(account, password: password)
//        }
    }
    
    // 判断输入的合法性
    //MARK:TODO
    private func checkAccountPassWord() -> Bool {
        
        if (self.accountTextField.text?.characters.count == 0 && self.passwordTextField.text?.characters.count == 0) {
            QNTool.showPromptView("请输入账号与密码")
            self.accountTextField.becomeFirstResponder()
            return false
        }else if(self.accountTextField.text?.characters.count == 0) {
            QNTool.showPromptView("请输入密码")
            self.passwordTextField.becomeFirstResponder()
            return false

        }else if (self.passwordTextField.text?.characters.count == 0){
            QNTool.showPromptView("请输入账号")
            self.accountTextField.becomeFirstResponder()
            return false
        }
        return true
        
    }
   }
