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

class CreateGroupViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CreateGroupTableViewCellDelegate  {
    
    @IBOutlet var searchUserTableView: UITableView!
    var searchBar: UISearchBar!
    //検索した時に表示されるユーザー
    var users = [User]()
    //追加したユーザーのobjectIdの配列
    var selectedUseObjectId = [NCMBUser.current().objectId!]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchUserTableView.dataSource = self
        searchUserTableView.delegate = self
        
        let nib = UINib(nibName: "CreateGroupTableViewCell", bundle: Bundle.main)
        searchUserTableView.register(nib, forCellReuseIdentifier: "Cell")
        searchUserTableView.tableFooterView = UIView()
        
        setSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeGroupName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //画面生成時にグループ名を作成
    func makeGroupName() {
        let alert = UIAlertController(title: "グループの作成", message: "グループ名を入力して下さい", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        //okした時の処理
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.navigationItem.title = alert.textFields?.first?.text
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField { (textField) in
            textField.placeholder = "ここにグループ名を入力"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func setSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:42)
        //searchbarの設置位置
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 85)
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "ユーザーIdを検索"
        searchBar.setValue("キャンセル", forKey: "_cancelButtonText")
        searchBar.tintColor = UIColor.blue
        
        //searchUserTableView.tableHeaderView = searchBar
        //searchbarを設置
        self.view.addSubview(searchBar)
    }
    
    // 検索ボタンが押された時に呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = true
        //検索
        loadUsers(searchText: searchBar.text)
        
        self.searchUserTableView.reloadData()
    }
    
    // キャンセルボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        self.searchUserTableView.reloadData()
    }
    
    // キャンセルボタンの表示
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CreateGroupTableViewCell
        
        cell.tag = indexPath.row
        cell.delegates = self
        
        cell.userNameLabel.text = users[indexPath.row].userName

        
        if selectedUseObjectId.contains(users[indexPath.row].objectId) {
            cell.addButton.setTitle("追加済み", for: .normal)
        } else {
            cell.addButton.setTitle("追加", for: .normal)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func loadUsers(searchText: String?) {
        let query = NCMBUser.query()
        query?.whereKey("objectId", notEqualTo: NCMBUser.current().objectId)
        // 退会済みアカウントを除外
        query?.whereKey("active", notEqualTo: false)
        // 検索ワードがある場合
        if let text = searchText {
            query?.whereKey("userName", equalTo: text)
        }
        // 新着ユーザー50人だけ拾う
        query?.limit = 50
        query?.order(byDescending: "createDate")
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 取得した新着50件のユーザーを格納
                self.users = [User]()
                for userObjects in result as! [NCMBUser] {
                    let objectId = userObjects.objectId
                    let userName = userObjects.userName
                    let user = User(objectId: objectId!, userName: userName!)
                    self.users.append(user)
                }
                self.searchUserTableView.reloadData()
            }
        })
      
    }
 
    //メンバーのobjectIdを追加
    func didTapAddButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        if selectedUseObjectId.contains(users[tableViewCell.tag].objectId) {
            button.setTitle("追加", for: .normal)
            let index = selectedUseObjectId.index(of: users[tableViewCell.tag].objectId)
            selectedUseObjectId.remove(at: index!)
            
        } else {
           selectedUseObjectId.append(users[tableViewCell.tag].objectId)
            button.setTitle("追加済み", for: .normal)
        }
    }
    
    //グループ作成ボタン
    @IBAction func makeGroup() {
        
        let alert = UIAlertController(title: "グループの削除", message: "グループ名を削除しますか", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        //okした時の処理
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)

            let object = NCMBObject(className: "Group")
            object?.setObject(self.navigationItem.title, forKey: "groupName")
            object?.setObject(self.selectedUseObjectId, forKey: "groupMemberObjectId")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil {
                    // SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    let alertController = UIAlertController(title: "成功", message: "グループ作成に成功しました", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
