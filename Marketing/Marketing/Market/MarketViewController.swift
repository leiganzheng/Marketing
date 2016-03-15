//
//  MarketViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/28.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class MarketViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate ,UISearchBarDelegate  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var customTableView: UITableView!
    @IBOutlet weak var customV: UIView!
    var categorys: [Category] =  NSArray() as! [Category]
    var goods: [Good] =  NSArray() as! [Good]
    var searchView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商城"
        self.customTableView.backgroundColor = defaultBackgroundGrayColor
        //数据
//       self.fetchCategoryData()
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
        if self.goods.count > 0{
            let good = self.goods[indexPath.row] as Good
            cell.nameLB.text = good.name
            cell.goodPic.sd_setImageWithURL(NSURL(string: good.picture!), placeholderImage: UIImage(named: ""), options: .ProgressiveDownload)
        }
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if self.goods.count > 0{
            let good = self.goods[indexPath.row] as Good
            let vc = OrderInfoViewController.CreateFromStoryboard("Main") as! OrderInfoViewController
            vc.hidesBottomBarWhenPushed = true
            vc.goodId = good.good_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((collectionView.frame.width-4)/3.0-8, 85)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(4, 4, 4, 4)
    }
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorys.count
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
        if self.categorys.count > 0 {
            let category = self.categorys[indexPath.row]
            cell.textLabel?.text = category.name
        }
        cell.textLabel?.text = "测试数据"
        cell.textLabel?.font = UIFont.systemFontOfSize(13)
        cell.textLabel?.textAlignment = .Center

        cell.addLine(0, y:43 , width: screenWidth, height: 1)

        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
         let category = self.categorys[indexPath.row]
         self.fetchGoods(category.cat_id)
    }
    // 搜索代理UISearchBarDelegate方法，每次改变搜索内容时都会调用
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //添加搜索数据
        let vc = GoodsListViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
       
    }
    //MARK: - Private Method
    func fetchCategoryData (){
        QNNetworkTool.fetchCategoryList { (array, error, errorMsg) -> Void in
            if array != nil {
                if array?.count>0 {
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
                if array?.count>0 {
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
