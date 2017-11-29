//
//  ViewController.swift
//  Happystagram
//
//  Created by User on 2017/07/16.
//  Copyright © 2017年 Yusuke Hirose. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var items = [NSDictionary]()
    
    let refreshControl = UIRefreshControl()
    
    var passImage:UIImage = UIImage()
    
    var nowtableViewImage = UIImage()
    
    var nowtableViewUserName = String()
    
    var nowtableViewUserImage = UIImage()
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "check") != nil{
        
        }else{
        
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated:true,completion: nil)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string:
        "引っ張って更新")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
            tableView.addSubview(refreshControl)
        
        items = [NSDictionary]()
        loadAllData()
        tableView.reloadData()

    }
    
    @objc func refresh(){
    
    //データを読んでくる
        
        
    //tableViewのリロード
    items = [NSDictionary]()
    loadAllData()
    tableView.reloadData()
    refreshControl.endRefreshing()
        
    
        
    }
    
    //tableViewのデリゲートメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    //セルの内容、処理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let dict = items[(indexPath as NSIndexPath).row - 1]
        
        
        
        //プロフィール
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        
        //デコードしたデータをUIImage型へ変換してImageViewへ反映する
      
        
        let decodedData = (base64Encoded: dict["profileImage"])
        let decodededData = NSData(base64Encoded:decodedData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage = UIImage(data: decodededData! as Data)
        profileImageView.image = decodedImage
        
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        
        //ユーザー名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = dict["username"] as? String
        
        //投稿画像
        let postedImageView = cell.viewWithTag(3) as! UIImageView
        let decodedData2 = (base64Encoded: dict["postImage"])
        let decodededData2 = NSData(base64Encoded:decodedData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage2 = UIImage(data: decodededData! as Data)
        profileImageView.image = decodedImage2
        
        //コメント
        let commentTextView = cell.viewWithTag(4) as! UITextView
        commentTextView.text = dict["comment"] as? String
        
        
        return cell
    }
    
    
    //データベースからデータを取ってきて、配列itemsの中に入れた
    func loadAllData(){
    
    // https://happystagram-afbd3.firebaseio.com/
        
        //ロードされている間refrexhコントローラーが自動で回ってくれる
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        let firebase  = Database.database().reference(fromURL: "// https://happystagram-afbd3.firebaseio.com/").child("Posts")
        
        
        firebase.queryLimited(toLast: 10).observe(.value) {(snapshot,error) in
            var tempItems = [NSDictionary]()
            for item in(snapshot.children){
            
                let child = item as! DataSnapshot
                let dict = child.value
                tempItems.append(dict as! NSDictionary)
            }
        
        self.items = tempItems
        //配列の中身の順番を逆にする(新しいものを画面の上に表示)
        self.items = self.items.reversed()
        NSLog("アイテム", self.items)
        self.tableView.reloadData()
            
        //更新終了でrefreshコントローラーを止める
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        
        }
    }
        
    
    
        
    
              
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = items[(indexPath as NSIndexPath).row]
        
        //エンコードして取り出す
        let decodeData = (base64Encoded:dict["profileImage"])
        
        let docodeData = NSData(base64Encoded:decodeData as! String , options:NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage = UIImage(data:decodeData! as! Data)
        nowtableViewUserImage = decodedImage!
        
        nowtableViewUserName = (dict["username"] as? String)!
        
        //エンコードして取り出す
        let decodeData2 = (base64Encoded:dict["postImage"])
        
        let docodeData2 = NSData(base64Encoded:decodeData2 as! String , options:NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage2 = UIImage(data:decodeData2! as! Data)
        nowtableViewImage = decodedImage2!
        
        performSegue(withIdentifier: "sns", sender: nil)

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
    
    @IBAction func showCamera(_ sender: Any) {
        
        openCamera()
        
    }
    
    @IBAction func showPhotos(_ sender: Any) {
        
        openPhoto()
        
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
           passImage = pickedImage
        performSegue(withIdentifier: "next", sender: nil)
        
        }
        
        //カメラ画面を閉じる処理
        imagePicker.dismiss(animated:true,completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "next"){
        
            let editVC:EditViewController = segue.destination as! EditViewController
            editVC.willEditImage = passImage
        
        }
    
        if (segue.identifier == "sns"){
        
            let snsVC:SnsViewController = segue.destination as! SnsViewController
            snsVC.detailImage = nowtableViewImage
            snsVC.detailProfileImage = nowtableViewUserImage
            snsVC.detailUserName = nowtableViewUserName
        
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

