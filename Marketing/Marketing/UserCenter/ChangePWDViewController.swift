//
//  ChangePWDViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/29.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class ChangePWDViewController: UIViewController , UITableViewDataSource, UITableViewDelegate,QNInterceptorProtocol {
    
    var titles: NSArray!
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
                let lb = UILabel(frame: CGRectMake(8,7,200, 30))
                lb.backgroundColor = UIColor.clearColor()
                lb.textColor = tableViewCellDefaultTextColor
                lb.textAlignment = NSTextAlignment.Left
                lb.font = UIFont.systemFontOfSize(15)
                let titleArray = self.titles[indexPath.section] as! NSArray
                lb.text = titleArray[indexPath.row] as? String
                cell.addSubview(lb)
            }
            return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}

