//
//  MyCollectionViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/29.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MyCollectionViewController: UIViewController , UITableViewDataSource, UITableViewDelegate,QNInterceptorProtocol{

    var titles: NSArray!
     @IBOutlet weak var customTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
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
        return 150
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "CollectionTableViewCell"
        var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! CollectionTableViewCell!
        if cell == nil {
            cell = (NSBundle.mainBundle().loadNibNamed(cellId, owner: self, options: nil) as NSArray).objectAtIndex(0) as! CollectionTableViewCell
            cell.accessoryType = .DisclosureIndicator
        }
        cell.deleteBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            return RACSignal.empty()
        })
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

}
