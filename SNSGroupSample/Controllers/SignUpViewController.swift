//
//  SignUpViewController.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/28.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sinUp() {
        
        let user = NCMBUser()
        if (userIdTextField.text?.count)! < 4 {
            let alertController = UIAlertController(title: "登録できません", message: "ユーザー名を４文字以上にしてください。", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        user.userName = userIdTextField.text!
        user.mailAddress = emailTextField.text!
        
        if (passwordTextField.text?.count)! < 6 {
            let alertController2 = UIAlertController(title: "登録できません", message: "パスワードを6文字以上にしてください。", preferredStyle: .alert)
            let action2 = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController2.addAction(action2)
            self.present(alertController2, animated: true, completion: nil)
        }  else if passwordTextField.text == confirmTextField.text      {
            user.password = passwordTextField.text!
        } else {
            let alertController3 = UIAlertController(title: "登録できません", message: "パスワードが一致しません。", preferredStyle: .alert)
            let action3 = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController3.addAction(action3)
            self.present(alertController3, animated: true, completion: nil)
        }
        
        
        user.signUpInBackground { (error) in
            if error != nil {
               // SVProgressHUD.showError(withStatus: error!.localizedDescription)
                
            } else {
                let acl = NCMBACL()
                acl.setPublicReadAccess(true)
                acl.setWriteAccess(true, for: user)
                user.acl = acl
                user.saveEventually({ (error) in
                    if error != nil {
                       // SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        //登録成功
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let rootViewcontroller = storyboard.instantiateViewController(withIdentifier: "RootMainController")
                        UIApplication.shared.keyWindow?.rootViewController = rootViewcontroller
                        //ログイン状態の保持
                        let ud = UserDefaults.standard
                        ud.set(true, forKey: "isLogin")
                        ud.synchronize()
                        
                    }
                })
            }
        }
    }
    
    
}
