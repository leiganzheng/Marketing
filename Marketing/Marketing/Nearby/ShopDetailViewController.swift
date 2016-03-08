//
//  ShopDetailViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/2.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class ShopDetailViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate   {
    
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var customTableView: UITableView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var headerV: UIView!
    var goods: [Good] =  NSArray() as! [Good]
    var shop: Shop!
    var shopId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商家详情"
        self.configBackButton()
        self.headerV.addLine(0, y: 110, width: screenWidth, height: 0.5)
        self.headerV.addLine(0, y:self.headerV.frame.size.height, width: screenWidth, height: 0.5)

        self.customTableView.backgroundColor = defaultBackgroundGrayColor
        //数据
        self.fetchCategoryData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- UICollectionDelegate, UICollectionDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.shop != nil {
            return self.goods.count == 0 ?10 :self.goods.count
        }
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "MarketCell"
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! MarketCollectionViewCell
        if self.goods.count != 0{
            let good = self.goods[indexPath.row] as Good
            cell.nameLB.text = good.name
            cell.goodPic.sd_setImageWithURL(NSURL(string: good.picture!), placeholderImage: UIImage(named: ""), options: .ProgressiveDownload)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        //        let object = self.titleArray.objectAtIndex(indexPath.row) as! NSDictionary
        let vc = OrderInfoViewController.CreateFromStoryboard("Main") as! OrderInfoViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = GoodsListViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((collectionView.frame.width-4)/3.0-8, 85)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(4, 4, 4, 4)
    }
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.shop != nil {
            return self.shop.category.count == 0 ?10 :self.shop.category.count
        }
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell: UITableViewCell! = self.customTableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        if self.shop.category.count != 0 {
            let category = self.shop.category[indexPath.row]
            cell.textLabel?.text = category.name
        }else {
            cell.textLabel?.text = "测试数据"
        }
        cell.textLabel?.font = UIFont.systemFontOfSize(13)
        cell.textLabel?.textAlignment = .Center
        cell.addLine(0, y:43 , width: screenWidth, height: 1)
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.shop.category.count != 0 {
            let category = self.shop.category[indexPath.row]
            self.fetchGoods(category.shop_cat_id)
        }
    }
    //MARK: - Private Method
    func fetchCategoryData (){
        QNNetworkTool.fetchShopDetailInfo(self.shopId,needCategory: "1", needGoods: "1") { (shop, error, errMsg) -> Void in
            if shop != nil {
                self.shop = shop!
                self.goods = self.shop.goods
                self.name.text = self.shop.name
                self.info.text = self.shop.info
                self.address.text = self.shop.address_detail
                self.customTableView.reloadData()
                self.collectionView.reloadData()
            }else {
                QNTool.showErrorPromptView(nil, error: error)
            }
        }
    }
    func fetchGoods(cateId:String){
        QNNetworkTool.fetchGoodList("", cat_id: "", shop_cat_id: cateId, promotion_type: "", name: "", verify: "", status: "", page: "", page_size: "", order: "") { (array, error, errorMsg) -> Void in
            if array != nil {
                if array?.count>=0 {
                    self.goods = array!
                    self.collectionView.reloadData()
                }else{
                    QNTool.showPromptView("没有数据")
                }
            }else {
                QNTool.showErrorPromptView(nil, error: error)
            }
        }
    }

    
}
