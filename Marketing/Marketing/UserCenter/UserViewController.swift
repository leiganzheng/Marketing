//
//  UserViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/28.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate{

    var titles: NSArray!
    var icons: NSArray!
    var moneyLbl : UILabel!
    @IBOutlet weak var customTableView: UITableView!
    var usrName : UILabel!
    var imgV : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titles = [[""],["我的订单","我的收藏"],["修改密码","退出登录"]]
        self.icons = [[""],["order","favite"],["change_pwd","exit"]]
        self.navigationController?.navigationBar.translucent = false // 关闭透明度效果
        // 让导航栏支持向右滑动手势
        QNTool.addInteractive(self.navigationController)
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
        return self.titles.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 112
        }else {
            return 48
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellId = "cell0"
            var cell: UITableViewCell! = self.customTableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            }
            let img = cell.viewWithTag(100) as! UIImageView
            if g_user?.picture != nil {
                img.sd_setImageWithURL(NSURL(string: (g_user?.picture)!), placeholderImage: nil)
            }
            let name = cell.viewWithTag(101) as! UILabel
            name.text = g_user?.nickname!
            let addres = cell.viewWithTag(102) as! UILabel
            addres.text = "地址：\(g_user?.role!)"
            return cell
        }else {
            let cellId = "cell1"
            var cell: UITableViewCell! = self.customTableView.dequeueReusableCellWithIdentifier(cellId)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                cell.accessoryType = .DisclosureIndicator
            }
            let titleArray = self.titles[indexPath.section] as! NSArray
            let iconsArray = self.icons[indexPath.section] as! NSArray
            cell.textLabel?.text = titleArray[indexPath.row] as? String
            cell.imageView?.image = UIImage(named: (iconsArray[indexPath.row] as? String)!)
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            let vc = MyOrderViewController.CreateFromStoryboard("Main") as! MyOrderViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if (indexPath.section == 1 && indexPath.row == 1){
            let vc = MyCollectionViewController.CreateFromStoryboard("Main") as! MyCollectionViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if (indexPath.section == 2 && indexPath.row == 0){
            let vc = ChangePWDViewController.CreateFromStoryboard("Main") as! ChangePWDViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if (indexPath.section == 2 && indexPath.row == 1){
            QNTool.enterLoginViewController()
//            QNNetworkTool.logout("", completion: { (succeed, error, errorMsg) -> Void in
//                
//            })
        }

    }
    
}
