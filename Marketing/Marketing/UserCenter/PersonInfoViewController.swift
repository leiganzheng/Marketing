//
//  PersonInfoViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/1/28.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit
import AliyunOSSiOS

class PersonInfoViewController:  BaseViewController ,QNInterceptorProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate{
    
    private enum Content: Int {
        case HeadImage = 0       // 头像
        case NickName = 1        // 姓名
        case phone = 2         // 注册手机
        case Save = 3
        static let count = 4    // 总数
        
        var title: String {
            switch self {
            case .HeadImage: return "我的头像"
            case .NickName:  return "我的昵称"
            case .phone: return "联系方式"
            case .Save:   return "保存资料"
            }
        }
    }
    private var userCenterData: [[Content]]!
    
    var tableView: UITableView!
    var headerView: UIImageView!
    var picker: UIImagePickerController?
    
    var nameLB: UITextField!
    var phoneLB: UILabel!
    var zoneLB: UILabel!
    var saveButton: UIButton!
    var changeButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationController?.navigationBar.translucent = false // 关闭透明度效果
        // 让导航栏支持向右滑动手势
        QNTool.addInteractive(self.navigationController)
        self.title = "个人资料"
        self.userCenterData = [[Content.HeadImage], [Content.NickName],[Content.phone],[Content.Save]]
        
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        self.tableView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.scrollEnabled = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        // 键盘消失
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        tap.rac_gestureSignal().subscribeNext { [weak self](tap) -> Void in
            self?.nameLB.resignFirstResponder()
        }
        self.view.addGestureRecognizer(tap)


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userCenterData[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return self.userCenterData.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch self.userCenterData[indexPath.section][indexPath.row] {
        case .HeadImage: return 80
        default: return 50
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "UserInfoViewController_Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            QNTool.configTableViewCellDefault(cell)
            cell.selectionStyle = .None
        }
        
        let content = self.userCenterData[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = content.title
        switch content {
        case .HeadImage:
            if self.headerView == nil {
                self.headerView = UIImageView(frame: CGRectMake(cell.contentView.bounds.size.width - 78, 6, 70, 70))
                self.headerView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
                self.headerView.layer.masksToBounds = true
                QNTool.configViewLayer(self.headerView)
                self.headerView.sd_setImageWithURL(NSURL(string: (g_user?.picture!)!), placeholderImage: UIImage(named: "avatar"))
            }
            cell.contentView.addSubview(self.headerView)
        case .NickName:
            if self.nameLB == nil {
                self.nameLB = UITextField(frame: CGRectMake(0, 0, 160, 50))
                self.nameLB.font = UIFont.systemFontOfSize(14)
                self.nameLB.textAlignment = NSTextAlignment.Right
                self.nameLB.textColor = UIColor(white: 66/255, alpha: 1)
                cell.accessoryView = self.nameLB
            }
            self.nameLB.text = g_user?.nickname
        case .phone:
            self.phoneLB = UILabel(frame: CGRectMake(40, 0, 160, 50))
            self.phoneLB.font = UIFont.systemFontOfSize(14)
            self.phoneLB.textAlignment = NSTextAlignment.Right
            self.phoneLB.textColor = UIColor(white: 66/255, alpha: 1)
            self.phoneLB.text = g_user?.mobile
            cell.contentView.addSubview(self.phoneLB)
            
            self.changeButton = UIButton(type: .Custom)
            changeButton.backgroundColor = UIColor.clearColor()
            changeButton.setTitle("更改", forState: .Normal)
            changeButton.setTitleColor(appThemeColor, forState: .Normal)
            changeButton.titleLabel?.font = UIFont.systemFontOfSize(14)
            changeButton.titleLabel?.textAlignment = .Center
            changeButton.frame =  CGRectMake(0, 0, 44 , cell.contentView.frame.size.height)
            changeButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
                let alertController = UIAlertController(title: "更换手机号",
                    message: "请输入用新手机号", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addTextFieldWithConfigurationHandler {
                    (textField: UITextField!) -> Void in
                    textField.placeholder = "新手机号"
                    textField.keyboardType = UIKeyboardType.NumberPad
                }
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "好的", style: .Default,
                    handler: {
                        action in
                        //也可以用下标的形式获取textField let login = alertController.textFields![0]
                        let phoneNum = alertController.textFields!.first! as UITextField
                        self.phoneLB.text = phoneNum.text
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            cell.accessoryView = self.changeButton
        case .Save:
            cell.textLabel?.text = ""
            self.saveButton = UIButton(type: .Custom)
            saveButton.backgroundColor = UIColor.clearColor()
            saveButton.setTitle(content.title, forState: .Normal)
            saveButton.setTitleColor(appThemeColor, forState: .Normal)
            saveButton.titleLabel?.font = UIFont.systemFontOfSize(14)
            saveButton.titleLabel?.textAlignment = .Center
            saveButton.frame =  CGRectMake(0, 0, cell.contentView.frame.size.width , 50)
            saveButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
                self.savePersonInfo()
            }
            cell.contentView.addSubview(saveButton)

        }
        QNTool.configTableViewCellDefault(cell)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section==0 && indexPath.row == 0{
            let actionSheet = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            actionSheet.addButtonWithTitle("从手机相册选择")
            actionSheet.addButtonWithTitle("拍照")
            actionSheet.rac_buttonClickedSignal().subscribeNext({ (index) -> Void in
                if let indexInt = index as? Int {
                    switch indexInt {
                    case 1, 2:
                        if self.picker == nil {
                            self.picker = UIImagePickerController()
                            self.picker!.delegate = self
                        }
                        
                        self.picker!.sourceType = (indexInt == 1) ? .SavedPhotosAlbum : .Camera
                        self.picker!.allowsEditing = true
                        self.presentViewController(self.picker!, animated: true, completion: nil)
                    default: break
                    }
                }
            })
            actionSheet.showInView(self.view)
        }
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // 存储图片
        let headImageData = UIImageJPEGRepresentation(image, 1)
        self.uploadUserFace(headImageData)
        
        self.picker?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.picker?.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if (NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView") {
            //做自己想做的事
            return false
        }
        return true
    }
  //MARK: Private Method
    // 上传头像
    private func uploadUserFace(imageData: NSData!) {
        if imageData == nil {
            QNTool.showPromptView("上传图片数据损坏", nil)
            return
        }
        QNTool.showActivityView("正在上传...", inView: self.view, nil)
        
        let endpoint = "cvs315.oss-cn-shenzhen.aliyuncs.com"
        let   AccessKey = "M0hObeWrViBiUfuU"
        let   SecretKey = "tO0Dvf5qNjbe6iKro5T8NT2QdXNcir"
        
        let credential = OSSPlainTextAKSKPairCredentialProvider(plainTextAccessKey: AccessKey, secretKey: SecretKey)
        let  client = OSSClient(endpoint: endpoint, credentialProvider: credential)
        let  put = OSSPutObjectRequest()
        
        put.bucketName = "cvs315"
        put.objectKey = "images/icon"

        put.uploadingData = imageData// 直接上传NSData
        let putTask = client.putObject(put)
        putTask.continueWithBlock { (task) -> AnyObject! in
            QNTool.hiddenActivityView()
            if (task.error == nil) {
                QNTool.showPromptView("上传成功", nil)
                let result = task.result as? OSSGetBucketResult
                for  objectInfo in result!.contents {
                    print("list object: %@", objectInfo)
                }

            }else{
                print("task.error=%@",task.error)
                QNTool.showPromptView("上传失败,点击重试或者重新选择图片", nil)
            }
            return nil
        }
        
    }

    func savePersonInfo(){
        QNNetworkTool.updateUserInfo((g_user?.uid)!, adminuser: (g_user?.adminuser)!, nickname: (g_user?.nickname)!, mobile: self.phoneLB.text!, picture: "") { (user, error, errorMsg) -> Void in
            if user != nil {
                QNTool.showPromptView("保存成功")
            }else{
                QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
            }
        }
    }
}
