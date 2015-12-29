//
//  OrderTableViewCell.swift
//  QooccDoctor
//
//  Created by leiganzheng on 15/12/29.
//  Copyright © 2015年 juxi. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
