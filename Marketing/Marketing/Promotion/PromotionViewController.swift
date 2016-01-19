//
//  PromotionViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/28.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class PromotionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    var titleArray: NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "促销"
        self.view.backgroundColor = defaultBackgroundGrayColor
        //数据
        self.titleArray = NSArray()
        
        // Do any additional setup after loading the view.
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
        
//        cell.customView.layer.masksToBounds = true
//        cell.customView.layer.cornerRadius = 3
//        let object = self.titleArray.objectAtIndex(indexPath.row) as! NSDictionary
        
//        // 配置选中时候的变色
//        let selectedBgView = UIView(frame: cell.contentView.bounds)
//        cell.selectedBackgroundView = selectedBgView
//        let selectedView = UIView(frame: cell.customView.frame)
//        selectedView.autoresizingMask = cell.customView.autoresizingMask
//        selectedView.backgroundColor = UIColor(white: 240.0/255.0, alpha: 1)
//        selectedView.layer.masksToBounds = true
//        selectedView.layer.cornerRadius = cell.customView.layer.cornerRadius
//        selectedBgView.addSubview(selectedView)
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
//        let object = self.titleArray.objectAtIndex(indexPath.row) as! NSDictionary
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(collectionView.frame.width/2.0-10, 245)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2, 2, 2, 2)
    }


}
