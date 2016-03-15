//
//  OrderDetailTableViewCell.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/6.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var shopNameLb: UILabel!
    @IBOutlet weak var buyNumlb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var effectiveLb: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var tipsLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
