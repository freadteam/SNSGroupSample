//
//  DetailViewController.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/28.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import NCMB

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var memberTableView: UITableView!
    @IBOutlet var groupNameLabel: UILabel!
    var users = [User]()
    var selectedGroup: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        
        let nib = UINib(nibName: "DetailTableViewCell", bundle: Bundle.main)
        memberTableView.register(nib, forCellReuseIdentifier: "Cell")
        memberTableView.tableFooterView = UIView()
        
        groupNameLabel.text = selectedGroup?.groupName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMembers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailTableViewCell
        
        cell.memberLabel.text = users[indexPath.row].userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadMembers() {
        let objectIds = selectedGroup?.memberObjectIds
        let query = NCMBUser.query()
        // 退会済みアカウントを除外
        query?.whereKey("active", notEqualTo: false)
        query?.whereKey("objectId", containedIn: objectIds!)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.users = [User]()
                for userObjects in result as! [NCMBUser] {
                    let objectId = userObjects.objectId
                    let userName = userObjects.userName
                    let user = User(objectId: objectId!, userName: userName!)
                    self.users.append(user)
                }
                self.memberTableView.reloadData()
            }
        })
    }
    
}
