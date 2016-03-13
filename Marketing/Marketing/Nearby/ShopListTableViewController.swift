//
//  ShopListTableViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/1.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class ShopListTableViewController: UITableViewController{

    var data: NSArray =  NSArray() as! [Shop]
    var businessCategory:BusinessCategory!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "附近商家"
        self.view.backgroundColor = defaultBackgroundGrayColor
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.rac_signalForControlEvents(UIControlEvents.ValueChanged).subscribeNext({ (input) -> Void in
            self.refreshControl?.endRefreshing()
        })

        self.tableView.separatorStyle = .None
        self.configBackButton()
        self.fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "reuseIdentifier"
        var cell: UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
             cell.addLine(0, y: 54, width: screenWidth, height: 0.5)
        }
        if self.data.count>0{
            let cate = self.data[indexPath.row] as! Shop
            cell.textLabel?.text = cate.name
            cell.detailTextLabel?.text = cate.address_detail
            
            
            let imgV = UIImageView(frame: CGRectMake(tableView.bounds.size.width - 45, 16, 8, 12))
            imgV.image = UIImage(named: "location")
            cell.contentView.addSubview(imgV)
            
            let lb1 = UILabel(frame:CGRectMake(imgV.frame.origin.x+12, 12, 25, 20))
            lb1.backgroundColor = UIColor.clearColor()
            lb1.textColor = tableViewCellDefaultTextColor
            lb1.textAlignment = NSTextAlignment.Left
            lb1.font = UIFont.systemFontOfSize(12)
            lb1.text = "距离"
            cell.contentView.addSubview(lb1)


            let lb = UILabel(frame:CGRectMake(tableView.bounds.size.width - 40, 25, 30, 30))
            lb.backgroundColor = UIColor.clearColor()
            lb.textColor = tableViewCellDefaultTextColor
            lb.textAlignment = NSTextAlignment.Left
            lb.font = UIFont.systemFontOfSize(12)
            lb.text = "\(NSString(format: "%i", cate.distance!))km"
            cell.contentView.addSubview(lb)
        
        }
        return cell
    }

   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let vc = ShopDetailViewController.CreateFromStoryboard("Main") as! ShopDetailViewController
    let cate = self.data[indexPath.row] as! Shop
    vc.shopId = cate.shop_id
    vc.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(vc, animated: true)

    }
    //MARK: - Private Method
    func fetchData (){
        QNNetworkTool.fetchShopList("", page: "1", business_cat_id: "", need_shop_address: "", page_size: "10", order: "") { (array, error, errorMsg) -> Void in
            if array != nil {
                if array?.count>=0 {
                    self.data = array!
                    self.tableView.reloadData()
                }else{
                    QNTool.showPromptView("没有数据")
                }
            }else{
                QNTool.showErrorPromptView(nil, error: error)
            }
        }
    }
}
