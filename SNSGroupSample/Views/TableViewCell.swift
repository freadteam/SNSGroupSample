//
//  TableViewCell.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/28.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton)
}

class TableViewCell: UITableViewCell {
    
    var delegate: TableViewCellDelegate?
    
    @IBOutlet var groupLabel: UILabel!
    @IBOutlet var createDateLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteButton(button: UIButton) {
        self.delegate?.didTapMenuButton(tableViewCell: self, button: button)
    }
    
}
