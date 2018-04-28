//
//  CreateGroupTableViewCell.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/28.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit

protocol CreateGroupTableViewCellDelegate {
    func didTapAddButton(tableViewCell: UITableViewCell, button: UIButton)
}

class CreateGroupTableViewCell: UITableViewCell {
    
    var delegates: CreateGroupTableViewCellDelegate?
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addMember(button: UIButton) {
        self.delegates?.didTapAddButton(tableViewCell: self, button: button)
       
    }
    
}
