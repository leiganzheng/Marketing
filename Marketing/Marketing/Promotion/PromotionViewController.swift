//
//  PromotionViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/28.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class PromotionViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    var titleArray: [Good] =  NSArray() as! [Good]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "促销"
        //数据
        self.fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UICollectionDelegate, UICollectionDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "PromotionCell"
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! PromotionCollectionViewCell
        cell.customView.layer.borderColor = defaultLineColor.CGColor
        cell.customView.layer.borderWidth = 0.5
            if self.titleArray.count != 0{
                let good = self.titleArray[indexPath.row] as Good
                cell.info.text = good.descriptionStr
                cell.buyNum.text = "\(good.buy_num)人已购买"
                cell.price.text  = "$\(good.price)"
                cell.pic.sd_setImageWithURL(NSURL(string: good.picture!), placeholderImage: UIImage(named: ""), options: .ProgressiveDownload)
        }
        print(cell)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
//        if self.titleArray.count != 0{
        
            let vc = OrderInfoViewController.CreateFromStoryboard("Main") as! OrderInfoViewController
             vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)

            
//            let vc = ShopDetailViewController.CreateFromStoryboard("Main") as! ShopDetailViewController
//            let good = self.titleArray[indexPath.row]
//            vc.shopId = good.shop_id
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print(collectionView)
            return CGSizeMake((collectionView.frame.width-4)/2.0-4, 245)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
         print(collectionView)
        return UIEdgeInsetsMake(6, 4, 6, 0)
    }
    //MARK: Private Method
    func fetchData (){
        //promotion_type 促销类型ID
        QNNetworkTool.fetchGoodList("", cat_id: "", shop_cat_id: "", promotion_type: "2", name: "", verify: "", status: "", page: "", page_size: "", order: "") { (goods, error, errorMsg) -> Void in
            if goods != nil {
                self.titleArray = goods!
                self.collectionView.reloadData()
            }else{
                QNTool.showErrorPromptView(nil, error: error)
            }

        }
       
    }

}
