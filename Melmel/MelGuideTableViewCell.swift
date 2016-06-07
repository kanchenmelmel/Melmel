//
//  MelGuideTableViewCell.swift
//  Melmel
//
//  Created by Work on 29/03/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreGraphics

class MelGuideTableViewCell: UITableViewCell {

    // Components in MelPostTableViewCell
    @IBOutlet weak var titleBackground: UIView!
    
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
