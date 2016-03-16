//
//  GoodsListViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/7.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class GoodsListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate{

    //展示列表
    var tableView: UITableView!
    var goods: [Good] =  NSArray() as! [Good]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "检索"
        self.configBackButton()
        //创建表视图
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight),
            style:UITableViewStyle.Plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView.backgroundColor = defaultBackgroundGrayColor
        self.tableView.separatorStyle = .None
        self.tableView.rowHeight = 110
        //创建一个重用的单元格
        self.tableView!.registerNib(UINib(nibName:"GoodTableViewCell", bundle:nil),
            forCellReuseIdentifier:"MyCell")
        self.view.addSubview(self.tableView!)
        //data
        self.fetchData()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UICollectionDelegate, UICollectionDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.goods.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let identify:String = "MyCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identify,
            forIndexPath: indexPath) as! GoodTableViewCell
        if self.goods.count > 0 {
            let good = self.goods[indexPath.row] as Good
            cell.title.text = good.name
            cell.imageV.sd_setImageWithURL(NSURL(string: good.picture!), placeholderImage: UIImage(named: ""), options: .ProgressiveDownload)
            cell.price.text = "￥\(good.discounted_price!)"
            cell.buyNum.text = "\(good.buy_num!)个人购买"
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let good = self.goods[indexPath.row] as Good
        let vc = OrderInfoViewController.CreateFromStoryboard("Main") as! OrderInfoViewController
        vc.hidesBottomBarWhenPushed = true
        vc.goodId = good.good_id
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: Private Method
    func fetchData (){
        QNNetworkTool.fetchGoodList("", cat_id: "", shop_cat_id: "", promotion_type: "", name: "", verify: "", status: "", page: "", page_size: "", order: "") { (goods, error, errorMsg) -> Void in
            if goods != nil {
                if goods?.count>0 {
                    self.goods = goods!
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


