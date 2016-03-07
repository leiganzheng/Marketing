//
//  GoodsListViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/7.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class GoodsListViewController: BaseViewController{

    //展示列表
    var tableView: UITableView!
    
    //搜索控制器
    var countrySearchController = UISearchController()
    
    //原始数据集
    let schoolArray = ["清华大学","北京大学","中国人民大学","北京交通大学","北京工业大学",
        "北京航空航天大学","北京理工大学","北京科技大学","中国政法大学","中央财经大学","华北电力大学",
        "北京体育大学","上海外国语大学","复旦大学","华东师范大学","上海大学","河北工业大学"]
    
    //搜索过滤后的结果集
    var searchArray:[String] = [String](){
        didSet  {self.tableView.reloadData()}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configBackButton()
        //创建表视图
        self.tableView = UITableView(frame: self.view.bounds,
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
        
        //配置搜索控制器
        self.countrySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "请输入关键字"
    
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Private Method
    func fetchData (){
        
    }

}
extension GoodsListViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.countrySearchController.active)
        {
            return self.searchArray.count
        } else
        {
            return self.schoolArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "MyCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCellWithIdentifier(identify,
            forIndexPath: indexPath)
        if (self.countrySearchController.active)
        {
            
//            cell.textLabel?.text = self.searchArray[indexPath.row]
            return cell
        }
            
        else
        {
//            cell.textLabel?.text = self.schoolArray[indexPath.row]
            return cell
        }
    }
}

extension GoodsListViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = OrderInfoViewController.CreateFromStoryboard("Main") as! OrderInfoViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GoodsListViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchArray.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@",
            searchController.searchBar.text!)
        let array = (self.schoolArray as NSArray)
            .filteredArrayUsingPredicate(searchPredicate)
        self.searchArray = array as! [String]
    }
}
