//
//  CommentTableViewCell.swift
//  Melmel
//
//  Created by WuKaipeng on 28/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    
    func setupView(){
        avatarImage.layer.cornerRadius = 25.0
        avatarImage.clipsToBounds = true
        
    }

}
