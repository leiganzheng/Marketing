//
//  NearbyViewController.swift
//  Marketing
//
//  Created by leiganzheng on 15/12/28.
//  Copyright © 2015年 leiganzheng. All rights reserved.
//

import UIKit

class NearbyViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout ,UIScrollViewDelegate{

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var galleryScrollView: UIScrollView!
    @IBOutlet weak var galleryPageControl: UIPageControl!
    var timer:NSTimer!
    var titleArray:NSArray =  NSArray() as! [BusinessCategory]
    var adArray:NSArray =  NSArray() as! [AdModel]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "附近"
        self.collectionView.backgroundColor = defaultBackgroundGrayColor
        //数据
        self.fetchData()
        self.fetchAds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- 解决iOS7下约束导致视图frame变化
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    //MARK:- UICollectionDelegate, UICollectionDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "NearbyCollectionCell1"
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! NearbySCollectionViewCell
        cell.customView.layer.borderColor = defaultLineColor.CGColor
        cell.customView.layer.borderWidth = 0.5
        if self.titleArray.count != 0 {
            let buss = self.titleArray.objectAtIndex(indexPath.row) as! BusinessCategory
            cell.pic.sd_setImageWithURL(NSURL(string: buss.picture!), placeholderImage: UIImage(named: ""), options: .ProgressiveDownload)
            cell.name.text = buss.name
            cell.descr.text = buss.descriptionStr
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let object = self.titleArray.objectAtIndex(indexPath.row) as! BusinessCategory
        let vc = ShopListTableViewController()
        vc.businessCategory = object
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake((collectionView.frame.width)/2.0-8, 78)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(6, 6, 6, 6)
    }
    
    //MARK: - Private Method
    func fetchData (){
        QNNetworkTool.fetchBusinessCategoryList { (array, error, errorMsg) -> Void in
        if array != nil {
            if array?.count>0 {
                self.titleArray = array!
                self.collectionView.reloadData()
            }else{
                QNTool.showPromptView("没有数据")
            }
        }else{
            QNTool.showErrorPromptView(nil, error: error)
        }
        }
    }
    func fetchAds(){
        QNNetworkTool.fetchAdList { (array, error, errMsg) -> Void in
            if array != nil {
                if array?.count != 0{
                    self.adArray = array!
                    self.pictureGallery()
                }else{
                    
                }
            }else {
                
            }
        }
    }
    func pictureGallery(){   //实现图片滚动播放；
        //image width
        let imageW:CGFloat = self.galleryScrollView.frame.size.width//获取ScrollView的宽作为图片的宽；
        let imageH:CGFloat = self.galleryScrollView.frame.size.height//获取ScrollView的高作为图片的高；
        let imageY:CGFloat = -64//图片的Y坐标就在ScrollView的顶端；
        let totalCount:NSInteger = self.adArray.count//轮播的图片数量；
        for index in 0..<totalCount{
            let imageView:UIImageView = UIImageView()
            let imageX:CGFloat = CGFloat(index) * imageW
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH)//设置图片的大小，注意Image和ScrollView的关系，其实几张图片是按顺序从左向右依次放置在ScrollView中的，但是ScrollView在界面中显示的只是一张图片的大小，效果类似与画廊；
            imageView.backgroundColor = UIColor.redColor()
            let ad = self.adArray.objectAtIndex(index) as! AdModel
            let url = NSURL(string: ad.picture!)
            imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: ""), options: .ProgressiveDownload)
            self.galleryScrollView.showsHorizontalScrollIndicator = false//不设置水平滚动条；
            self.galleryScrollView.addSubview(imageView)//把图片加入到ScrollView中去，实现轮播的效果；
        }
        
        //需要非常注意的是：ScrollView控件一定要设置contentSize;包括长和宽；
        let contentW:CGFloat = imageW * CGFloat(totalCount)//这里的宽度就是所有的图片宽度之和；
        self.galleryScrollView.contentSize = CGSizeMake(contentW, 0)
        self.galleryScrollView.pagingEnabled = true
        self.galleryScrollView.delegate = self
        self.galleryPageControl.numberOfPages = totalCount//下面的页码提示器；
        if totalCount != 1 {
            self.addTimer()
        }
        
    }
    func nextImage(sender:AnyObject!){//图片轮播；
        var page:Int = self.galleryPageControl.currentPage
        if(page == self.adArray.count){   //循环；
            page = 0
        }else{
            page++
        }
        let x:CGFloat = CGFloat(page) * self.galleryScrollView.frame.size.width
        self.galleryScrollView.contentOffset = CGPointMake(x, 0)//注意：contentOffset就是设置ScrollView的偏移；
    }
    //UIScrollViewDelegate中重写的方法；
    //处理所有ScrollView的滚动之后的事件，注意 不是执行滚动的事件；
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //这里的代码是在ScrollView滚动后执行的操作，并不是执行ScrollView的代码；
        //这里只是为了设置下面的页码提示器；该操作是在图片滚动之后操作的；
        let scrollviewW:CGFloat = galleryScrollView.frame.size.width;
        let x:CGFloat = galleryScrollView.contentOffset.x;
        let page:Int = (Int)((x + scrollviewW / 2) / scrollviewW);
        self.galleryPageControl.currentPage = page;
        
    }
    func addTimer(){   //图片轮播的定时器；
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nextImage:", userInfo: nil, repeats: true);
    }
}
