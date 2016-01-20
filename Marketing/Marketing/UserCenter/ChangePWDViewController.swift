//
//  ChangePWDViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/29.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class ChangePWDViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate,QNInterceptorProtocol,UITextFieldDelegate {
    
    var titles: NSArray!
    var oldPwd: UITextField!
    var newPwd: UITextField!
    var newPwdAgin: UITextField!
    var okButton: UIButton!
    @IBOutlet weak var customTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        self.titles = [["请输入当前密码"],["请输入您的新密码","请再次输入您的新密码"],["修改密码"]]
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellId = "cell"
            var cell: UITableViewCell! = self.customTableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            }
        if indexPath.section == 0 && indexPath.row == 0{
            self.oldPwd = UITextField(frame: CGRectMake(15, 0, cell.contentView.bounds.width - 15, cell.contentView.bounds.height))
            oldPwd.backgroundColor = UIColor.clearColor()
            self.oldPwd.delegate = self
            self.oldPwd.tag = 1000
            oldPwd.font = UIFont.systemFontOfSize(15)
            oldPwd.placeholder = "请输入当前密码"
            oldPwd.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            cell.addSubview(oldPwd)

        }
        if  indexPath.section == 1 && indexPath.row == 0 {
            self.newPwd = UITextField(frame: CGRectMake(15, 0, cell.contentView.bounds.width - 15, cell.contentView.bounds.height))
            newPwd.backgroundColor = UIColor.clearColor()
            self.newPwd.delegate = self
            self.newPwd.tag = 1000
            newPwd.font = UIFont.systemFontOfSize(15)
            newPwd.placeholder = "请输入您的新密码"
            newPwd.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            cell.addSubview(newPwd)

        }
        if indexPath.section == 1 && indexPath.row == 1  {
            self.newPwdAgin = UITextField(frame: CGRectMake(15, 0, cell.contentView.bounds.width - 15, cell.contentView.bounds.height))
            newPwdAgin.backgroundColor = UIColor.clearColor()
            self.newPwdAgin.delegate = self
            self.newPwdAgin.tag = 1000
            newPwdAgin.font = UIFont.systemFontOfSize(15)
            newPwdAgin.placeholder = "请再次输入您的新密码"
            newPwdAgin.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            cell.addSubview(newPwdAgin)

        }
        if indexPath.section == 2 && indexPath.row == 0  {
            self.okButton = UIButton(type: .Custom)
            okButton.backgroundColor = UIColor.clearColor()
            okButton.setTitle("修改密码", forState: .Normal)
            okButton.setTitleColor(appThemeColor, forState: .Normal)
            okButton.titleLabel?.font = UIFont.systemFontOfSize(15)
            okButton.titleLabel?.textAlignment = .Center
            okButton.frame =  CGRectMake(0, 0, cell.contentView.frame.size.width , cell.contentView.frame.size.height)
            okButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self](sender) -> Void in
//                if let strongSelf = self {
//                    
//                }
            }
            cell.contentView.addSubview(okButton)
            
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    //MARK:- UItextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

