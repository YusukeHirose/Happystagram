//
//  SnsViewController.swift
//  Happystagram
//
//  Created by User on 2017/07/26.
//  Copyright © 2017年 Yusuke Hirose. All rights reserved.
//

import UIKit
import Social

class SnsViewController: UIViewController {
    
    //投稿されている画像
    var detailImage = UIImage()
    
    //プロフィール画像
    var detailProfileImage = UIImage()
    
    var detailUserName = String()
    
    var myComposeview:SLComposeViewController!
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    @IBOutlet var label: UILabel!
    
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileImageView.image = detailProfileImage
        label.text = detailUserName
        imageView.image = detailImage
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        
    }
    
    
    @IBAction func shareTwitter(_ sender: Any) {
        
        myComposeview = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        //投稿するテキスト
        
        let string = "#Happystagram" + " photo by" + label.text!
        
        myComposeview.setInitialText(string)
        
        myComposeview.add(imageView.image)
        
        //表示する
        self.present(myComposeview, animated: true, completion: nil)
        
        
        
        
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
