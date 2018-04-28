//
//  CreateGroupViewController.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/28.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import NCMB
import SwiftDate

class CreateGroupViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SearchUserTableViewCellDelegate  {
    
    @IBOutlet var searchUserTableView: UITableView!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUserTableView.dataSource = self
        searchUserTableView.delegate = self
        
      
        let nib = UINib(nibName: "CreateGroupTableViewCell", bundle: Bundle.main)
        searchUserTableView.register(nib, forCellReuseIdentifier: "Cell")
        searchUserTableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
