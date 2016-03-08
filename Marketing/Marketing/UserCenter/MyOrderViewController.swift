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
    
    var dataArray:NSArray =  NSArray() as! [Order]
     @IBOutlet weak var customTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的订单"
        self.customTableView.separatorStyle = .None
        //
        self.fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
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
        if self.dataArray.count != 0{
            let order = self.dataArray[indexPath.row] as! Order
            cell.name.text = order.shopInfo!.name
            if order.goods.count > 0{
                let good = order.goods[0]
                cell.name1.text = good.good_name
                cell.imageV.sd_setImageWithURL(NSURL(string: good.good_pic!), placeholderImage: UIImage(named: ""), options: .ProgressiveDownload)
                cell.detail.text = "消费：\(good.price!)"
                cell.time.text = "时间：\(order.create_time!)"
            }
            if order.status == "0" {
                cell.payBtn.setTitle("马上支付", forState: .Normal)
                cell.payBtn.rac_command = RACCommand(signalBlock: { (sender) -> RACSignal! in
                    let vc = PayOrderViewController.CreateFromStoryboard("Main") as! PayOrderViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    return RACSignal.empty()
                })

            }else if(order.status == "1"){
                cell.payBtn.setTitle("已经支付", forState: .Normal)
                cell.payBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            }
        }
        cell.customV.addLine(0, y: 34, width: tableView.frame.size.width, height: 0.5)
       
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = OrderDetailViewController.CreateFromStoryboard("Main") as! OrderDetailViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Private Method
    func fetchData (){
        QNNetworkTool.fetchOrderList("", shop_id: "", uid: (g_user?.uid)!, payment_id: "", pay_sn: "", evaluation_status: "", shipping_code: "", customer_address: "", status: "", need_order_goods: "1", accesstoken:  (g_user?.accesstoken)!, page: "1", page_size: "10") { (orders, error, errorMsg) -> Void in
            if orders != nil {
                if orders?.count > 0{
                    self.dataArray = orders!
                    self.customTableView.reloadData()
                }else {
                    QNTool.showPromptView("没有数据")
                }
            }else{
                QNTool.showErrorPromptView(nil, error: error)
            }
        }
        
    }

}
