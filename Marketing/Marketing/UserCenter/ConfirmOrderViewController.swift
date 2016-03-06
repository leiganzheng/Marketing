//
//  ConfirmOrderViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/5.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate,QNInterceptorProtocol {

    @IBOutlet weak var customTableView: UITableView!
    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认订单"
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         return indexPath.section == 0 ? 44 : 105
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01*COEFFICIENT_OF_HEIGHT_ZOOM
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0{
                let cellId = "TableViewCell1"
                var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell1!
                if cell == nil {
                    cell = TableViewCell1(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                return cell

            }else if(indexPath.row == 1){
                let cellId = "TableViewCell2"
                var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell2!
                if cell == nil {
                    cell = TableViewCell2(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                return cell
            }else if(indexPath.row == 2){
                let cellId = "TableViewCell3"
                var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell3!
                if cell == nil {
                    cell = TableViewCell3(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                return cell

            }else if(indexPath.row == 3){
                let cellId = "TableViewCell4"
                var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell4!
                if cell == nil {
                    cell = TableViewCell4(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                return cell

            }else{
                let cellId = "TableViewCell5"
                var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell5!
                if cell == nil {
                    cell = TableViewCell5(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                return cell

            }
            
        }else{
            let cellId = "TableViewCell6"
            var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell6!
            if cell == nil {
                cell = TableViewCell6(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            }
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    //MARK: Action Method
    @IBAction func postOrder(sender: AnyObject) {
    }
    //MARK: Private Method
    func fetchData (){
        
    }


}
