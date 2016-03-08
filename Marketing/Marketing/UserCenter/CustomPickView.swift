//
//  CustomPickView.swift
//  QooccDoctor
//
//  Created by leiganzheng on 15/9/10.
//  Copyright (c) 2015年 leiganzheng. All rights reserved.
//

import UIKit
import ReactiveCocoa

class CustomPickView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    var deletBtn: UIButton!
    var pickerView: UIPickerView!
    var footView: UIView!
    var dataArray : NSMutableArray! = NSMutableArray()
    var cityArray : NSMutableArray! = NSMutableArray()
    var areaArray : NSMutableArray! = NSMutableArray()
    var selectProvincial : String!
    var selectCity : String!
    var selectData: String!
    var finished: ((data: String) -> Void)? // 完成的回调
    var selected: ((parent: String,level: String) -> Void)? // 完成的回调
    var cusViewController : UIViewController!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()

        self.footView = UIView(frame: CGRectMake(0, frame.size.height - 284, frame.size.width, 284))
        self.footView.backgroundColor = UIColor.whiteColor()
        // 初始化 myPickerView
        let head = UIView(frame: CGRectMake(0, 0, frame.size.width, 50))
        let line01 = UIView(frame: CGRectMake(0, 0, frame.size.width, 1))
        line01.backgroundColor = defaultLineColor
        let line02 = UIView(frame: CGRectMake(0, 49, frame.size.width, 1))
        line02.backgroundColor = defaultLineColor
        head.addSubview(line01)
        head.addSubview(line02)
        
        let button1 = UIButton(type:.System)
        button1.frame = CGRectMake(25, 0, 40, 50)
        button1.setTitle("取消", forState: UIControlState.Normal)
        button1.rac_command = RACCommand(signalBlock: { [weak self](sender) -> RACSignal! in
            if let strongSelf = self {
                strongSelf.hideAsPop()
            }
            return RACSignal.empty()
            })
        button1.tag = 1
        button1.setTitleColor(defaultGrayColor, forState: UIControlState.Normal)
        button1.titleLabel?.font = UIFont.systemFontOfSize(17)
        //
        let button2 = UIButton(type:.System)
        button2.frame = CGRectMake(frame.width - 65, 0, 40, 50)
        button2.setTitle("确定", forState: UIControlState.Normal)
        button2.titleLabel?.font = UIFont.systemFontOfSize(17)
        button2.rac_command = RACCommand(signalBlock: { [weak self](sender) -> RACSignal! in
            if let strongSelf = self {
                strongSelf.finished!(data :(self?.selectData)!)
                strongSelf.hideAsPop()
            }
            return RACSignal.empty()
            })
        button2.tag = 2
        button2.setTitleColor(appThemeColor, forState: UIControlState.Normal)
        head.addSubview(button1)
        head.addSubview(button2)
        self.footView.addSubview(head)
        
        pickerView = UIPickerView(frame: CGRectMake(0, 44, frame.width, 234))
        pickerView.delegate = self
        pickerView.dataSource = self
        // 显示选中框，iOS7 以后不起作用
        pickerView.showsSelectionIndicator = false
        footView.addSubview(pickerView)
        self.addSubview(self.footView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIPickerViewDelegate, UIPickerViewDataSource
    // 设置列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    // 设置行数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
             return self.dataArray.count
        }else if(component == 1){
             return self.cityArray.count
        }else{
             return self.areaArray.count
        }
       
    }
    
    // 设置每行具体内容（titleForRow 和 viewForRow 二者实现其一即可）
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            let data = dataArray[row] as? CityData
            return data!.name
        } else if(component == 1){
            let data = cityArray[row] as? CityData
            return data!.name
        }else{
            let data = areaArray[row] as? CityData
            return  data!.name
        }
    }
    
    // 选中行的操作
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            let data = dataArray[row] as? CityData
            self.selected!(parent: data!.id!,level: "2")
            self.selectProvincial = data?.name
        } else if(component == 1){
            let data = cityArray[row] as? CityData
            self.selected!(parent: data!.id!,level: "3")
            self.selectCity = data?.name
        }else{
            let data = areaArray[row] as? CityData
            self.selected!(parent: data!.parent!,level: "")
            self.selectData = self.selectProvincial+self.selectCity+(data?.name!)!
        }
    }
}

