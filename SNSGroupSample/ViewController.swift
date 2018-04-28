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


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate {
    
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
        cell.delegate = self
        
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
                       
                        let userModel = User(objectId: user.objectId, userName: user.userName)
                        // 投稿の情報を取得
                        let groupName = postObjects.object(forKey: "groupName") as! String
                        let memberObjectIds = postObjects.object(forKey: "groupMemberObjectId") as! [String]
                        
                        //自分のグループだけ持ってくる
                        if memberObjectIds.contains(NCMBUser.current().objectId) {
                            // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                            let group = Group(objectId: postObjects.objectId, user: userModel,memberObjectIds: memberObjectIds, createDate: postObjects.createDate, groupName: groupName)
                            // 配列に加える
                            self.groups.append(group)
                        }
                    }
                }
                self.groupTableView.reloadData()
            }
        })
        
        
    }
    
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton) {
        let alert = UIAlertController(title: "グループの削除", message: "グループ名を削除しますか", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        //okした時の処理
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            let query = NCMBQuery(className: "Group")
            query?.getObjectInBackground(withId: self.groups[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    // SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    // 取得した投稿オブジェクトを削除
                    post?.deleteInBackground({ (error) in
                        if error != nil {
                            //SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            // 再読込
                            self.loadGroup()
                            // SVProgressHUD.showSuccess(withStatus: "投稿の削除が完了しました。")
                        }
                    })
                }
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
}
    //ログアウト、退会
    @IBAction func showmenu() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください。", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            //        ① コントローラーの実装
            let checkAlertController = UIAlertController(title: "ログアウト",message: "ログアウトしますか？", preferredStyle: UIAlertControllerStyle.alert)
            //        ②-1 OKボタンの実装
            let okAction = UIAlertAction(title: "ログアウトする", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                //        ②-2 OKがクリックされた時の処理
                NCMBUser.logOutInBackground({ (error) in
                    if error != nil {
                        let alertController2 = UIAlertController(title: "ログアウト失敗", message: "ログアウトできませんでした。", preferredStyle: .alert)
                        let action2 = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        alertController2.addAction(action2)
                        self.present(alertController2, animated : true, completion: nil)
                    } else {
                        //登録成功
                        let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                        let rootViewcontroller = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                        UIApplication.shared.keyWindow?.rootViewController = rootViewcontroller
                        //ログイン状態の保持
                        let ud = UserDefaults.standard
                        ud.set(false, forKey: "isLogin")
                        ud.synchronize()
                    }
                })
            }
            //        CANCELボタンの実装
            let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: nil)
            checkAlertController.dismiss(animated: true, completion: nil)
            //        ③-1 ボタンに追加
            checkAlertController.addAction(okAction)
            //        ③-2 CANCELボタンの追加
            checkAlertController.addAction(cancelButton)
            
            //        ④ アラートの表示
            self.present(checkAlertController,animated: true,completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            
            let alert = UIAlertController(title: "会員登録の解除", message: "本当に退会しますか？退会した場合、再度このアカウントをご利用頂くことができません。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "退会する", style: .default, handler: { (action) in
                // ユーザーのアクティブ状態をfalseに
                if let user = NCMBUser.current() {
                    user.setObject(false, forKey: "active")
                    user.saveInBackground({ (error) in
                        if error != nil {
                           // SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            // userのアクティブ状態を変更できたらログイン画面に移動
                            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                            UIApplication.shared.keyWindow?.rootViewController = rootViewController
                            // ログイン状態の保持
                            let ud = UserDefaults.standard
                            ud.set(false, forKey: "isLogin")
                            ud.synchronize()
                        }
                    })
                } else {
                    // userがnilだった場合ログイン画面に移動
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    // ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            })
            let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: nil)
            alert.dismiss(animated: true, completion: nil)
            //        ③-1 ボタンに追加
            alert.addAction(okAction)
            //        ③-2 CANCELボタンの追加
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
