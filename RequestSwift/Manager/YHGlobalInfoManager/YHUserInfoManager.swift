//
//  YHUserInfoManager.swift
//  RequestSwift
//
//  Created by YHIOS002 on 16/12/14.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation

open class YHUserInfoManager {
    
    static let shareInstanced = YHUserInfoManager()
    /**
     *  当前登录的用户信息(单例)
     */
    var userInfo:YHUserInfo? = nil
    var isHandleringTokenExpried:Bool = false //正在处理token失效
    var companyWeb:String? = nil  //公司网页(通知用户跳转下载App)
    var aboutArray:[YHAboutModel]? = []
    var bindQQSuccess:Bool  = false //成功绑定QQ
    var bindWechatSuccess:Bool = false
    var bindSinaSuccess:Bool   = false
    
    // MARK: - Public
    //登录成功
    func loginSuccess(userInfo:YHUserInfo) {
        //1.更新当前用户单例信息
        self.userInfo = userInfo
        self.isHandleringTokenExpried = false
        
        //2.更新用户的偏好设置
        _updateUserDefaults(userInfo: &self.userInfo!)
        
        //3.获取我的名片信息
        _getMyCardDetail()
    }
    
    //退出登录
    func logout(){
        //1.清除“已登录”标志
        _clearLoginInfoFromUserDefaults()
        
        //2.解除社交账号授权

        
        //3.登出清除全部聊天记录

        //4.清除用户单例信息
        userInfo = nil
        
        //5.发出“账号退出”通知 (备注：放在最后)
        NotificationCenter.default.post(name: Notification.Name(rawValue:Event_Logout), object: nil)
        
    }
    
    //token是否有效
    func valideUserToken(complete:@escaping NetManagerCallback) {
        
        guard self.userInfo != nil else{
            complete(false,"userInfo is nil")
            return
        }
        
        YHNetManager.shareInstanced.postValidateToken(userInfo: self.userInfo!, complete: {
            (success:Bool,obj:Any) in
            if success {
                print("Token 有效,可以继续使用")
                complete(true, "Token 有效,可以继续使用")
            }else{
                if obj is Dictionary<String,Any> {
                    //服务器返回的错误描述
                    UserDefaults.standard.set(false, forKey: kLoginOAuth)
                    UserDefaults.standard.synchronize()
                    complete(false, obj)
                }else{
                    complete(false,obj)
                }
            }
        })
    }
    
    
    // MARK: - private
    /**
     *  更新用户的偏好设置
     *
     *  @param userInfo 用户Model
     */
    func _updateUserDefaults(userInfo:inout YHUserInfo) {
        //1.条件判断
        if userInfo.uid == nil {
           userInfo.uid = ""
        }
        
        if userInfo.accessToken == nil {
            userInfo.accessToken = ""
        }
        
        if userInfo.mobilephone == nil {
            userInfo.mobilephone = ""
        }
        
        //保存“手机”
        UserDefaults.standard.set(userInfo.mobilephone, forKey: kMobilePhone)
        //保存"已登录标记"
        UserDefaults.standard.set(true, forKey: kLoginOAuth)
        //保存“用户Id”
        UserDefaults.standard.set(userInfo.uid, forKey: kUserUid)
        //保存“令牌”
        UserDefaults.standard.set(userInfo.accessToken, forKey:kAccessToken)
        //保存“token登录时间点”
        let ts = NSDate().timeIntervalSince1970
        UserDefaults.standard.set(ts, forKey:kAccessTokenDate)
        UserDefaults.standard.synchronize()

    }
    
    //获取我的名片
    func _getMyCardDetail() {
        YHNetManager.shareInstanced.getMyCardDetail(complete:
            {[unowned self] (success:Bool,obj:Any)  in
                if success{
                    print("获取我的名片成功:\(obj)")
                    
                    //1.更新当前用户单例信息
                    self.userInfo = obj as? YHUserInfo
                    self.userInfo?.updateStatus = .finish
                }else{
                    
                    if obj is Dictionary<String,Any>{
                        //服务器返回的错误描述
                        if let dict = obj as? Dictionary<String,Any>{
                            let msg = dict[kRetMsg]
                            print("获取我的名片失败:\(msg)")
                        }else{
                            print("获取我的名片失败")
                        }
                    }else{
                        print("获取我的名片失败:\(obj)")
                    }
                }
        })
    }
    
    //从UserDefaults中清除登录信息
    func _clearLoginInfoFromUserDefaults(){
        //1.清除“已登录”标志
        UserDefaults.standard.set(false, forKey: kLoginOAuth)
        UserDefaults.standard.set("", forKey: kTaxAccount)
        UserDefaults.standard.set(0, forKey: kAccessTokenDate)
        UserDefaults.standard.set("", forKey: kAccessToken)
        UserDefaults.standard.set("", forKey: kError_VerifyCode_WrongCount)
        UserDefaults.standard.set("", forKey:IM_SendMessage_Name )
        UserDefaults.standard.set("", forKey:IM_SendMessage_AvatarUrlString )
    }

    
}

struct YHAboutModel {
    var  url:URL? = nil
    var  title:String? = ""
    var  aboutId:String? = ""
}

