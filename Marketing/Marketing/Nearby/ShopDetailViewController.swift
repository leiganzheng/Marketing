//
//  ShopDetailViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/2.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class ShopDetailViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate   {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var customTableView: UITableView!
    var titles: [ShopCategory] =  NSArray() as! [ShopCategory]
    var titleArray: NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商家详情"
        self.configBackButton()
        //数据
        self.titleArray = NSArray()
        self.fetchCategoryData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UICollectionDelegate, UICollectionDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "MarketCell"
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! MarketCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        //        let object = self.titleArray.objectAtIndex(indexPath.row) as! NSDictionary
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width/3.0-10, 85)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
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
        let category = self.titles[indexPath.row]
        cell.textLabel?.text = category.name
        let lb = UILabel(frame: CGRectMake(0,65,85, 1))
        lb.backgroundColor = UIColor(white: 136/255, alpha: 1)
        cell.addSubview(lb)
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    //MARK: - Private Method
    func fetchCategoryData (){
        QNNetworkTool.fetchShopCategoryList { (array, error, errorMsg) -> Void in
            if array != nil {
                if array?.count>=0 {
                    self.titles = array!
                    self.customTableView.reloadData()
                }else{
                    QNTool.showPromptView("没有数据")
                }
            }else{
                QNTool.showErrorPromptView(nil, error: error)
            }
        }
    }
    
}
