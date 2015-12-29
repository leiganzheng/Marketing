//
//  ChangePWDViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/29.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class ChangePWDViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var titles: NSArray!
    @IBOutlet weak var customTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        self.titles = ["我的订单","我的收藏","修改密码","退出登录"]
        // Do any additional setup after loading the view.
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
        return 112
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell1"
        var cell: UITableViewCell! = self.customTableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            cell.accessoryType = .DisclosureIndicator
        }
        //            let titleArray = self.titles[indexPath.section] as! NSArray
        //            let iconsArray = self.icons[indexPath.section] as! NSArray
        //            cell.textLabel?.text = titleArray[indexPath.row] as? String
        //            cell.imageView?.image = UIImage(named: (iconsArray[indexPath.row] as? String)!)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}

