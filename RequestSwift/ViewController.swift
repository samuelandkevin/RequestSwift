//
//  ViewController.swift
//  RequestSwift
//
//  Created by YHIOS002 on 16/12/9.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var uploadImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
       
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func login(_ sender: Any) {
        YHNetManager.shareInstanced.postLogin(phoneNum: "13539467126", passwd: "123456", complete: {
            (success:Bool,obj:Any) in
            if success{
                print("登录成功")
            }else{
                print("登录失败,obj:\(obj)")
            }
        })
    }
    
    @IBAction func validToken(_ sender: Any) {
        YHUserInfoManager.shareInstanced.valideUserToken { (success:Bool, obj:Any) in
            if success {
                print("token is valid:\(obj)")
            }else{
                 print("token is unvaliable:\(obj)")
            }
        }
    }
    
    
    @IBAction func uploadImage(_ sender: Any) {
        guard  let img = UIImage(named: "img1.jpg") else {
            print("pic is nil")
            return
        }
        
        YHNetManager.shareInstanced.postUploadImage(image: img, complete: {
            (success:Bool,obj:Any) in
            if success{
                print("上传头像成功:\(obj)")
                var userInfo = YHUserInfo()
                userInfo.avatarUrl = obj as? URL
                YHNetManager.shareInstanced.postEditMyCard(userInfo: userInfo, complete: {
                    (success:Bool,obj:Any) in
                    
                    if success{
                        print("修改用户头像成功:\(obj)")
                    }else{
                        print("修改用户头像失败:\(obj)")
                    }
                })
            }else{
                print("上传头像失败:\(obj)")
            }
        }, progress: {
            (bytesWritten:Int64,totalBytesWritten:Int64) in
            print("\(bytesWritten)---\(totalBytesWritten)")
        })
        
    }
    @IBAction func modifyUserInfo(_ sender: Any) {
        
        var userInfo = YHUserInfo()
        userInfo.workCity = "广州嗯嗯嗯嗯嗯嗯"
        userInfo.company = "公司是事实上事实上"
        userInfo.industry = "行业职能啊"
        userInfo.job = "职位水水水水"
        userInfo.intro = "介绍"
        
        YHNetManager.shareInstanced.postEditMyCard(userInfo: userInfo, complete: {
            (success:Bool,obj:Any) in
            
            if success{
                print("修改用户信息成功:\(obj)")
            }else{
                print("修改用户信息失败:\(obj)")
            }
        })
    }
    
    @IBAction func logout(_ sender: Any) {
        YHNetManager.shareInstanced.postLogout(complete: {
            (success:Bool,obj:Any) in
            if success{
                print("退出登录成功:\(obj)")
            }else{
                print("退出登录失败:\(obj)")
            }
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}

