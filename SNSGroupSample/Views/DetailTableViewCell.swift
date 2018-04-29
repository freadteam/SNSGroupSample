//
//  DetailTableViewCell.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/29.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit



class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet var memberLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
