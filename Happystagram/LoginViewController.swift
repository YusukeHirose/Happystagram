//
//  LoginViewController.swift
//  Happystagram
//
//  Created by User on 2017/07/16.
//  Copyright © 2017年 Yusuke Hirose. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    @IBAction func createNewUser(_ sender: Any) {
        
        //入力欄が空のとき
        if emailTextField.text == nil || passwordTextField.text == nil{
        
        let alertViewController = UIAlertController(title: "おっと", message: "入力欄が空の状態です!", preferredStyle: .alert)
            
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
        alertViewController.addAction(okAction)
        present(alertViewController, animated:  true, completion: nil)
            
            
        }else{
        
        //入力欄がしっかり埋められている時の処理
        //新規ユーザー登録
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            //成功したとき
            if error == nil{
                
                UserDefaults.standard.set("check", forKey: "check")
                
                self.dismiss(animated: true, completion: nil)
                
            }else{
                //失敗したとき
                let alertViewController = UIAlertController(title: "おっと", message: error?.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertViewController.addAction(okAction)
                self.present(alertViewController, animated:  true, completion: nil)
                
            }
            
            
        })
        
        }
        
    }
    
    
    @IBAction func userLogin(_ sender: Any) {
        
        //ログイン
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            //成功したとき
            if error == nil{
                
                
                
            }else{
                //失敗したとき
                let alertViewController = UIAlertController(title: "おっと", message: error?.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertViewController.addAction(okAction)
                self.present(alertViewController, animated:  true, completion: nil)
                
            }
            
            
            
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
