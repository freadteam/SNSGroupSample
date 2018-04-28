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
    var selectedGroup: Group?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTableView.delegate = self
        groupTableView.dataSource = self
        
        let nib = UINib(nibName: "TableViewCell", bundle: Bundle.main)
        groupTableView.register(nib, forCellReuseIdentifier: "Cell")
        groupTableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadGroup()
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
        
        cell.tag = indexPath.row
        
        //let user = groups[indexPath.row].user
        cell.groupLabel.text = "グループ名：\(groups[indexPath.row].groupName)"
        cell.createDateLabel.text = "作成日：\(groups[indexPath.row].createDate.string())"
        
        return cell
    }
    //セルの高さを指定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedGroup = groups[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.selectedName = selectedGroup?.groupName
        }
    }
    
    
    func loadGroup() {
        let query = NCMBQuery(className: "Group")
        // 降順
        query?.order(byDescending: "createDate")
        
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.groups = [Group]()
                for postObjects in result as! [NCMBObject] {
                    let user = postObjects.object(forKey: "user") as! NCMBUser
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if  user.object(forKey: "active") as? Bool != false {
                       
                        // 投稿の情報を取得
                        let groupName = postObjects.object(forKey: "groupName") as! String
                        let userId = postObjects.object(forKey: "groupMemberObjectId") as! [String]
                        
                        //自分のグループだけ持ってくる
                        if userId.contains(NCMBUser.current().objectId) {
                            // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                            let group = Group(objectId: postObjects.objectId, userId: userId, createDate: postObjects.createDate, groupName: groupName)
                            // 配列に加える
                            self.groups.append(group)
                        }
                    }
                }
                self.groupTableView.reloadData()
            }
        })
        
        
    }
    
    
    
    
    
}

