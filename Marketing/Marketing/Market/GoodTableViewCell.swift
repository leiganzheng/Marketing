//
//  GoodTableViewCell.swift
//  Marketing
//
//  Created by leiganzheng on 16/3/8.
//  Copyright © 2016年 leiganzheng. All rights reserved.
//

import UIKit

class GoodTableViewCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var buyNum: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
