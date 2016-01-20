//
//  MyOrderViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/29.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MyOrderViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate,QNInterceptorProtocol{
    
    var titles: NSArray!
     @IBOutlet weak var customTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的订单"
        self.titles = ["我的订单","我的收藏","修改密码","退出登录"]
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
        let cellId = "OrderTableViewCell"
        var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! OrderTableViewCell!
        if cell == nil {
            cell = OrderTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        cell.addLine(0, y: 34, width: tableView.frame.size.width, height: 0.5)
        cell.payBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
            let vc = PayOrderViewController.CreateFromStoryboard("Main") as! PayOrderViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return RACSignal.empty()
            })

        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}
