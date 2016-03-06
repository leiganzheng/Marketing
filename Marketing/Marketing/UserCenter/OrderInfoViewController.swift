//
//  OrderInfoViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/6.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class OrderInfoViewController:  BaseViewController , UITableViewDataSource, UITableViewDelegate,QNInterceptorProtocol{
    
    @IBOutlet weak var customTableView: UITableView!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认订单"
        let imgV = UIImageView(frame: CGRectMake(0, 0, screenWidth, 162))
        imgV.image = UIImage(named: "nav_nearby1")
        imgV.backgroundColor = UIColor.lightGrayColor()
        self.customTableView.tableHeaderView = imgV

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 340
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "OrderDetailTableViewCell"
        var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! OrderDetailTableViewCell!
        if cell == nil {
            cell = OrderDetailTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        return cell
    }
    //MARK: Action Method
    @IBAction func buyAction(sender: AnyObject) {
        let vc = ConfirmOrderViewController.CreateFromStoryboard("Main") as! ConfirmOrderViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    //MARK: Private Method
   

}
