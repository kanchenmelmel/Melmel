//
//  DiscountTableViewCell.swift
//  Melmel
//
//  Created by WuKaipeng on 19/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class DiscountTableViewCell: UITableViewCell {

    @IBOutlet weak var featureImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
