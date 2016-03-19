//
//  ConfirmOrderViewController.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/5.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit
import FMDB
class CityData: NSObject {
    private(set) var id: String!
    private(set) var name: String?
    private(set) var level: String?
    private(set) var parent: String?
    private(set) var code: String?

}
class ConfirmOrderViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate,QNInterceptorProtocol {

    @IBOutlet weak var customTableView: UITableView!
    @IBOutlet weak var okButton: UIButton!
    var address:UILabel!
    var shopGood:ShopGood!
    
    var total:String!
    var reciever: String!
    var mobiel:String!
    var memo:String!
    var addressDetail:String!
    
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
                self.total = cell.totalNum.text
                //
                cell.numAddBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self](sender) -> Void in
                    if let strongSelf = self {
                        cell.totalNum.text = String(Int(cell.totalNum.text!)!+1)
                        strongSelf.total = cell.totalNum.text
                    }
                }
                //
                cell.numDBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self](sender) -> Void in
                    if let strongSelf = self {
                        let num = Int(cell.totalNum.text!)!-1 <= 0 ? 0 : Int(cell.totalNum.text!)!-1
                        cell.totalNum.text = String(num)
                        strongSelf.total = cell.totalNum.text
                    }
                }

                return cell

            }else if(indexPath.row == 1){
                let cellId = "TableViewCell2"
                var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell2!
                if cell == nil {
                    cell = TableViewCell2(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                self.reciever = cell.reciverLb.text
                return cell
            }else if(indexPath.row == 2){
                let cellId = "TableViewCell3"
                var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell3!
                if cell == nil {
                    cell = TableViewCell3(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                self.mobiel = cell.mobileLb.text
                return cell

            }else if(indexPath.row == 3){
                let cellId = "TableViewCell4"
                var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell4!
                if cell == nil {
                    cell = TableViewCell4(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                self.address = cell.lb
                return cell

            }else{
                let cellId = "TableViewCell5"
                var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell5!
                if cell == nil {
                    cell = TableViewCell5(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
                }
                self.addressDetail = cell.addressLB.text
                return cell

            }
            
        }else{
            let cellId = "TableViewCell6"
            var cell = self.customTableView.dequeueReusableCellWithIdentifier(cellId) as! TableViewCell6!
            if cell == nil {
                cell = TableViewCell6(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            }
            self.memo = cell.memoLb.text
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 3 {
            self.showPickerView()
        }
    }
    //MARK: Action Method
    func showPickerView(){
        //获取省级数据
        let sql = "SELECT * from address WHERE level = ?"
        let tmpData = self.selectDB(sql, para: "1")
        
        if tmpData!.count == 0 {
            return
        }
        //获取城市数据
        let firstData = tmpData![0] as! CityData
        let sql1 = "SELECT * from address WHERE level = 2 and parent = ?"
        let tmpData1 = self.selectDB(sql1, para: firstData.id!)
        
        if tmpData1!.count == 0 {
            return
        }
        let firstData1 = tmpData1![0] as! CityData
        //获取地区数据
        let sql2 = "SELECT * from address WHERE level = 3 and parent = ?"
        let tmpData2 = self.selectDB(sql2, para: firstData1.id!)
        
        let pickView = CustomPickView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        pickView.dataArray = tmpData
        pickView.cityArray = tmpData1
        pickView.areaArray = tmpData2
        pickView.showAsPop()
        pickView.finished = { (data) -> Void in
           self.address.text = data
        }
        pickView.selected = { (parent,level) -> Void in
            if level == "2" {
                let sql = "SELECT * from address WHERE level = 2 and parent = ?"
                let tmpData1 = self.selectDB(sql, para: parent)
                let firstData1 = tmpData1![0] as! CityData
                //获取地区数据
                let sql2 = "SELECT * from address WHERE level = 3 and parent = ?"
                let tmpData2 = self.selectDB(sql2, para: firstData1.id!)
                pickView.cityArray = tmpData1
                pickView.areaArray = tmpData2
                pickView.pickerView.reloadComponent(1)
                pickView.pickerView.reloadComponent(2)
            }
            if level == "3" {
                let sql = "SELECT * from address WHERE level = 3 and parent = ?"
                let tmpData2 = self.selectDB(sql, para: parent)
                pickView.areaArray = tmpData2
                pickView.pickerView.reloadComponent(2)
            }
           
        }
    }
     func getDB()->FMDatabase{
         let databasePath = NSBundle.mainBundle().pathForResource("address", ofType: "db")
        let db = FMDatabase(path: databasePath)
            if db == nil {
                println("Error: \(db.lastErrorMessage())")
            }
        return db
    }
    func selectDB(sql:String,para:String)->NSMutableArray?{
        let db = self.getDB()
        db.open()
          let nameArray:NSMutableArray?=NSMutableArray()
        if  let rs = db.executeQuery(sql, withArgumentsInArray: [para]) {
            while rs.next() {
                let data:CityData=CityData()
                data.id = rs.stringForColumn("id")
                data.name = rs.stringForColumn("name")
                data.level = rs.stringForColumn("level")
                data.parent = rs.stringForColumn("parent")
                data.code = rs.stringForColumn("code")
                nameArray?.addObject(data)
            }
        }else{
            println("select failed: \(db.lastErrorMessage())")
        }
        db.close()
        return nameArray
    }
    @IBAction func postOrder(sender: AnyObject) {
        self.fetchData()
    }
    //MARK: Private Method
    private  func paramsToJsonDataParams(params: [String : AnyObject]) -> String {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
            let jsonDataString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            return jsonDataString
        }catch{
            return ""
        }
    }

    func fetchData (){
        if self.shopGood == nil {return}
        let goods = self.paramsToJsonDataParams(["good_id": self.shopGood.good_id, "total": self.total])
        QNNetworkTool.orderAdd(self.shopGood.shop_id!, accesstoken: (g_user?.accesstoken)!, uid: (g_user?.uid)!, receiver:self.reciever,receiver_phone:self.mobiel, customer_address_id: (self.address.text! + self.addressDetail), order_goods: goods,memo: self.memo, good_id: self.shopGood.good_id, total: self.total) { (order, error, errorMsg) -> Void in
            if order != nil {
                QNTool.showPromptView("订单已经提交")
                let vc = PayOrderViewController.CreateFromStoryboard("Main") as! PayOrderViewController
                vc.order = order!
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
            }

        }
    }


}
