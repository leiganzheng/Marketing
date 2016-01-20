//
//  NearbyViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/28.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    var titleArray: NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "附近"
        self.view.backgroundColor = defaultBackgroundGrayColor
        //数据
        self.titleArray = NSArray()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- 解决iOS7下约束导致视图frame变化
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if SYSTEM_VERSION_FLOAT < 8.0 {
            self.collectionView.frame = CGRectMake(2, collectionView.frame.origin.y, screenWidth, collectionView.frame.size.height)
        }
    }

    //MARK:- UICollectionDelegate, UICollectionDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let identify:String = "NearbyCollectionCell2"
            let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath) as! NearbyBCollectionViewCell
            cell.customView.layer.borderColor = defaultLineColor.CGColor
            cell.customView.layer.borderWidth = 0.5
            return cell
        }else {
            let identify:String = "NearbyCollectionCell1"
            let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath) as! NearbySCollectionViewCell
            cell.customView.layer.borderColor = defaultLineColor.CGColor
            cell.customView.layer.borderWidth = 0.5
            return cell
        }
       
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        //        let object = self.titleArray.objectAtIndex(indexPath.row) as! NSDictionary
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSizeMake(collectionView.frame.width/2.0-6, 150)
        }else {
            return CGSizeMake(collectionView.frame.width/2.0-6, 78)
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2, 2, 2, 0)
    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
//    {
//         return 0
//    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 1
//    }
}
