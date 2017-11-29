//
//  SettingViewController.swift
//  Happystagram
//
//  Created by User on 2017/07/22.
//  Copyright © 2017年 Yusuke Hirose. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        
    }
    
    func openCamera(){
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            //インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true,completion: nil)
            
        }
        
    }
    
    func openPhoto(){
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            //インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true,completion: nil)
            
        }
        
        
        
    }

    
    
    @IBAction func changeProfile(_ sender: Any) {
        
        let alertViewController = UIAlertController(title: "選択してください。", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action:UIAlertAction) -> Void in
            
            //処理をかく
            self.openCamera()
            
            })
            
        let photosAction = UIAlertAction(title: "アルバム", style: .default, handler: {(action:UIAlertAction) -> Void in
            
            //処理をかく
            self.openPhoto()
            
        })

        let cancelAction =  UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertViewController.addAction(cameraAction)
        alertViewController.addAction(photosAction)
        alertViewController.addAction(cancelAction)
        
        present(alertViewController, animated:  true, completion: nil)

        
    }
    
    
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickeImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            profileImageView.contentMode = .scaleToFill
            profileImageView.image = pickeImage
            // backImageView.image = pickedImage
            
        }
        
        //カメラ画面を閉じる処理
        imagePicker.dismiss(animated:true,completion: nil)
    }

    
    
    @IBAction func logout(_ sender: Any) {
        
        try! Auth.auth().signOut()
        
        UserDefaults.standard.removeObject(forKey: "check")
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func done(_ sender: Any) {
        
        var data: NSData = NSData()
        if let image = profileImageView.image{
        
            data = UIImageJPEGRepresentation(image, 0.1)! as NSData
        
        }
        let userName = usernameTextField.text
        let base64String = data.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters)as String
        
        //アプリ内へ保存する
        UserDefaults.standard.set(base64String,forKey:"profileImage")
        UserDefaults.standard.set(userName,forKey:"userName")
        dismiss(animated:true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //キーボードが出ていたら
        if (usernameTextField.isFirstResponder){
        //キーボード閉じる
            usernameTextField.resignFirstResponder()
            
        }
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
