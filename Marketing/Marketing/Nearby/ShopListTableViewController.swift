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
//        self.data = ["dd","dd","dd"]
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
        return 60
    }
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "reuseIdentifier"
        var cell: UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        if self.data.count>0{
            let cate = self.data[indexPath.row] as! Shop
            cell.textLabel?.text = cate.name
            cell.detailTextLabel?.text = cate.info
        }

        return cell
    }

   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let vc = ShopDetailViewController.CreateFromStoryboard("Main") as! ShopDetailViewController
    vc.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(vc, animated: true)

    }
    //MARK: - Private Method
    func fetchData (){
        QNNetworkTool.fetchShopList("", page: "", business_cat_id: "", need_shop_address: "", page_size: "", order: "") { (array, error, errorMsg) -> Void in
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
