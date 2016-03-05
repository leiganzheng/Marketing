//
//  MarketViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/28.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class MarketViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate   {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var customTableView: UITableView!
    var categorys: [Category] =  NSArray() as! [Category]
    var goods: [Good] =  NSArray() as! [Good]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商城"
        //数据
       self.fetchCategoryData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UICollectionDelegate, UICollectionDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goods.count
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
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width/3.0-8, 85)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2, 2, 2, 2)
    }
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorys.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell: UITableViewCell! = self.customTableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        let category = self.categorys[indexPath.row]
        cell.textLabel?.text = category.name
        let lb = UILabel(frame: CGRectMake(0,65,85, 1))
        lb.backgroundColor = UIColor(white: 136/255, alpha: 1)
        cell.addSubview(lb)

        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
         let category = self.categorys[indexPath.row]
         self.fetchGoods(category.cat_id)
    }
    //MARK: - Private Method
    func fetchCategoryData (){
        QNNetworkTool.fetchCategoryList { (array, error, errorMsg) -> Void in
            if array != nil {
                if array?.count>=0 {
                    self.categorys = array!
                    self.customTableView.reloadData()
                    if self.categorys.count != 0{
                        let category = self.categorys[0]
                        self.fetchGoods(category.cat_id)
                    }
                }else{
                    QNTool.showPromptView("没有数据")
                }
            }else{
                QNTool.showErrorPromptView(nil, error: error)
            }
        }
    }
    func fetchGoods(cateId:String){
        QNNetworkTool.fetchGoodList("", cat_id: "", shop_cat_id: "", promotion_type: "", name: "", verify: "", status: "", page: "", page_size: "", order: "") { (array, error, errorMsg) -> Void in
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
