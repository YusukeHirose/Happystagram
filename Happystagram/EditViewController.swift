//
//  EditViewController.swift
//  Happystagram
//
//  Created by User on 2017/07/25.
//  Copyright © 2017年 Yusuke Hirose. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController,UITextViewDelegate {

    var willEditImage:UIImage = UIImage()
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var myProfileImageView: UIImageView!
    
    @IBOutlet var commentTextView: UITextView!
    
    @IBOutlet var myProfileLabel: UILabel!
    
    var usernameString:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = willEditImage
        commentTextView.delegate = self
        myProfileLabel.layer.cornerRadius = 8.0
        myProfileImageView.clipsToBounds = true
        
        if UserDefaults.standard.object(forKey: "profileImage") != nil{
        
            //エンコードして取り出す
            let decodeData = UserDefaults.standard.object(forKey: "profileImage")
            
            let docodeData = NSData(base64Encoded:decodeData as! String , options:NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodedImage = UIImage(data:decodeData! as! Data)
            myProfileImageView.image = decodedImage
            
            let usernameString = UserDefaults.standard.object(forKey: "userName")
            
            myProfileLabel.text = usernameString as! String
            
            
        }else{
        
            myProfileImageView.image = UIImage(named:"logo.png")
            myProfileLabel.text = "匿名"
        }
    }
    
    
    @IBAction func post(_ sender: Any) {
        
        postAll()
        
    }
    
    func postAll(){
    
        let databaseRef = Database.database().reference()
        
        //ユーザー名
        let username = myProfileLabel.text!
        
        //コメント
        let message = commentTextView.text!
        
        //投稿画像
        var data:NSData = NSData()
        if let image = imageView.image{
        
            data = UIImageJPEGRepresentation(image,0.1) as! NSData
            
        }
        
        let base64String = data.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        //プロフィール画像
        var data2:NSData = NSData()
        if let image2 = myProfileImageView.image{
            
            data2 = UIImageJPEGRepresentation(image2,0.1) as! NSData
        }
        
        let base64String2 = data.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        //サーバーに飛ばす箱
        let user:NSDictionary = ["usernaem":username,"comment":message,"postImage":base64String,"profileImage":base64String2]
        databaseRef.child("Posts").childByAutoId().setValue(user)
        
        //戻る
        self.navigationController?.popToRootViewController(animated: true)

        
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
