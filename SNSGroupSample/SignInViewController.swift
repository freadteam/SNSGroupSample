//
//  SignInViewController.swift
//  SNSGroupSample
//
//  Created by Ryo Endo on 2018/04/28.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import NCMB

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userTextField:UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTextField.delegate = self
        passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //textviewを閉じるコードを書く
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func singIn() {
        
        if (userTextField.text?.count)! > 0 && (passwordTextField.text?.count)! > 0  {
            NCMBUser.logInWithUsername(inBackground: userTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    //SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    if user?.object(forKey: "active") as? Bool == false {
                       // SVProgressHUD.setStatus("そのユーザーは退会済みです。")
                    } else {
                        //ここに入った時点でsignInできてる！！
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let rootViewcontroller = storyboard.instantiateViewController(withIdentifier: "RootMainController")
                        UIApplication.shared.keyWindow?.rootViewController = rootViewcontroller
                        
                        //ログイン状態の保持
                        let ud = UserDefaults.standard
                        ud.set(true, forKey: "isLogin")
                        ud.synchronize()
                    }
                }
            }
        }
    }
}
