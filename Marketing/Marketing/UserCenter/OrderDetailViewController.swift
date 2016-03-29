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
    var orderId: String!
    @IBOutlet weak var customTableView: UITableView!
    var usrName : UILabel!
    var imgV : UIImageView!
    var order: Order!
    var staus: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的订单"
        self.configBackButton()
        self.titles = [["店名"],["收货信息","快递单号","订单状态"]]
        self.navigationController?.navigationBar.translucent = false // 关闭透明度效果
        
        // 获取验证码的按钮
        let payButton = UIButton(frame: CGRect(x: 0, y: 0, width:50, height: 44))
        payButton.backgroundColor = UIColor.clearColor()
        payButton.setTitle("支付", forState: .Normal)
        payButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        payButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        payButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self](sender) -> Void in
            if let strongSelf = self {
                let vc = PayOrderViewController.CreateFromStoryboard("Main") as! PayOrderViewController
                vc.order = strongSelf.order!
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: payButton)
        
        // 让导航栏支持向右滑动手势
        QNTool.addInteractive(self.navigationController)
        //
        self.fetchData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            if self.staus == "1" {
                return 2
            }
            return 3
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.titles.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }else {
            if self.staus == "1" {
                if(indexPath.row == 0){
                    return 130
                }else{
                    return 55
                }

            }else{
                if(indexPath.row == 0){
                    return 130
                }else if(indexPath.row == 1){
                    return 70
                }else{
                    return 55
                }
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
            if self.order != nil {
                cell.name.text = self.order.shopInfo?.name
                let goods = self.order.goods
                if goods.count > 0{
                    let good = goods[0]
                    cell.name1.text = good.good_name
                    cell.imageV.sd_setImageWithURL(NSURL(string: good.good_pic!), placeholderImage: UIImage(named: "avatar"), options: .ProgressiveDownload)
                    cell.detail.text = "消费：\(good.price!)"
                    cell.time.text = "时间：\(self.order.create_time!)"
                }
            }
            return cell
        }else if (indexPath.section == 1){
            if(indexPath.row == 0){
                let cellId = "OrderTableViewCell1"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
                if cell == nil{
                    cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                    QNTool.configTableViewCellDefault(cell)
                    cell.selectionStyle = .None
                }
                if self.order != nil{
                    let lb1 = cell.viewWithTag(100) as! UILabel
                    lb1.text = "收件人：\(self.order.receiver!)"
                    let lb2 = cell.viewWithTag(101) as! UILabel
                    lb2.text = "联系电话：\(self.order.receiver_phone!)"
                    let lb3 = cell.viewWithTag(102) as! UILabel
                    lb3.text = "通讯地址：\(self.order.customer_address!)"
                }
                return cell
            }else {
                if self.staus == "1" {// 1 已支付
                    let cellId = "OrderTableViewCell3"
                    var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
                    if cell == nil{
                        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                        QNTool.configTableViewCellDefault(cell)
                        cell.selectionStyle = .None
                    }
                    if self.order != nil{
                        let lb1 = cell.viewWithTag(104) as! UILabel
                        lb1.text =  "已经签收"
                        
                    }
                    return cell
                }else{
                    if(indexPath.row == 1){
                        let cellId = "OrderTableViewCell2"
                        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
                        if cell == nil{
                            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                            QNTool.configTableViewCellDefault(cell)
                            cell.selectionStyle = .None
                            
                        }
                        if self.order != nil{
                            let lb1 = cell.viewWithTag(103) as! UILabel
                            lb1.text = self.order.shipping_company! + "  " + self.order.shipping_code!
                            
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
                        if self.order != nil{
                            let lb1 = cell.viewWithTag(104) as! UILabel
                            lb1.text = "已经签收"
                            
                        }
                        return cell
                    }
                }
            }
        }
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    //MARK: Private Method
    func fetchData(){
        QNNetworkTool.fetchOrderInfo(self.orderId, accesstoken: (g_user?.accesstoken)!) { (order, error, errorMsg) -> Void in
            if order != nil {
                self.order = order!
                self.staus = self.order.status!
                if self.staus == "1" {
                    self.navigationItem.rightBarButtonItem=nil
                }
                self.customTableView.reloadData()
            }else{
                QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
            }
        }
    }
}
