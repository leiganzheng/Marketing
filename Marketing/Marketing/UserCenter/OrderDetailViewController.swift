//
//  OrderDetailViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/2.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class OrderDetailViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate{
    
    var titles: NSArray!
    var moneyLbl : UILabel!
    @IBOutlet weak var customTableView: UITableView!
    var usrName : UILabel!
    var imgV : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的订单"
        self.configBackButton()
        self.titles = [["店名"],["收货信息","快递单号","订单状态"]]
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
            return 150
        }else {
            if(indexPath.row == 0){
                return 130
            }else if(indexPath.row == 1){
                return 70
            }else{
                return 55
            }
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cellId = "OrderTableViewCell"
            var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! OrderTableViewCell!
            if cell == nil {
                cell = OrderTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            }
            cell.addLine(0, y: 34, width: tableView.frame.size.width, height: 0.5)
            return cell
        }else {
            if(indexPath.row == 0){
                let cellId = "OrderTableViewCell1"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
                if cell == nil{
                    cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                    QNTool.configTableViewCellDefault(cell)
                    cell.selectionStyle = .None
                }
                return cell
            }else if(indexPath.row == 1){
                let cellId = "OrderTableViewCell2"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
                if cell == nil{
                    cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                    QNTool.configTableViewCellDefault(cell)
                    cell.selectionStyle = .None
                }
                return cell
            }else{
                let cellId = "OrderTableViewCell3"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
                if cell == nil{
                    cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                    QNTool.configTableViewCellDefault(cell)
                    cell.selectionStyle = .None
                }
                return cell
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}
