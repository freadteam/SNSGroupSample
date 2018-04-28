//
//  ViewController.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/28.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import NCMB
import SwiftDate


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var groupTableView: UITableView!
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTableView.delegate = self
        groupTableView.dataSource = self
        
        let nib = UINib(nibName: "TableViewCell", bundle: Bundle.main)
        groupTableView.register(nib, forCellReuseIdentifier: "Cell")
        groupTableView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        //let user = groups[indexPath.row].user
        cell.groupLabel.text = "グループ名：\(groups[indexPath.row].groupName)"
        cell.createDateLabel.text = "作成日：\(groups[indexPath.row].createDate.string())"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func loadGroup() {
        let query = NCMBQuery(className: "Group")
        // 降順
        query?.order(byDescending: "createDate")
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
    }
    
    
  
    
}

