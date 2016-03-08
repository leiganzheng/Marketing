//
//  PayOrderViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/29.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class PayOrderViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate,QNInterceptorProtocol {
    
    var titles: NSArray!
    var subTitles: NSArray!
    var icons: NSArray!
    @IBOutlet weak var customTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单支付"
        self.titles = ["微信支付","支付宝"]
        self.subTitles = ["微信安全支付","支付宝快捷支付"]
        self.icons = ["pay_weixn","pay_zhifubao"]
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
        return 55
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        customView.backgroundColor = defaultBackgroundGrayColor
        let lb = UILabel(frame: CGRectMake(8,5,200, 30))
        lb.backgroundColor = UIColor.clearColor()
        lb.textColor = tableViewCellDefaultTextColor
        lb.textAlignment = NSTextAlignment.Left
        lb.font = UIFont.systemFontOfSize(15)
        lb.text = "请支付"
        customView.addSubview(lb)
        
        let lb1 = UILabel(frame: CGRectMake(tableView.frame.size.width-110,5,100, 30))
        lb1.backgroundColor = UIColor.clearColor()
        lb1.textColor = tableViewCellDefaultTextColor
        lb1.textAlignment = NSTextAlignment.Right
        lb1.font = UIFont.systemFontOfSize(15)
        lb1.text = "¥200元"
        customView.addSubview(lb1)
        
        return customView
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell1"
        var cell: UITableViewCell! = self.customTableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            cell.accessoryType = .DisclosureIndicator
        }
        cell.textLabel?.text = self.titles[indexPath.row] as? String
        cell.imageView?.image = UIImage(named: (icons[indexPath.row] as? String)!)
        cell.detailTextLabel?.text = self.subTitles[indexPath.row] as? String
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
      
    }
    //微信支付
//    private func wxPayCheck(){
//        if WXApi.isWXAppInstalled() {
//            QNNetworkTool.wxpayOrderCheck(self.order!.orderNo, completion: { (dictionary, error, errorMsg) -> Void in
//                if dictionary != nil {
//                    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                    delegate.submitOrder(dictionary!, vc: self)
//                }else {
//                    QNTool.showPromptView( errorMsg!)
//                }
//            })
//        }else{
//            QNTool.showPromptView( "请安装微信客户端")
//        }
//    }

}

