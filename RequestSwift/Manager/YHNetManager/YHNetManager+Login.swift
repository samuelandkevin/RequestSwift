//
//  YHNetManager+Login.swift
//  RequestSwift
//
//  Created by YHIOS002 on 16/12/13.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation

extension YHNetManager {
    
    /**
     *  验证手机号码是否已注册
     *
     *  @param phoneNum 手机号码
     *  @param complete 结果回调
     */
    func getVerifyPhoneNum(phoneNum:String,complete:@escaping NetManagerCallback){
        
        let requestUrl = "\(kBaseURL)\(kPathVerifyPhoneExist)"
        let dict = ["mobile":phoneNum,
                    TaxTaoAppIdKey:TaxTaoAppId]
        
        getRequestWithUrl(requestUrl, paramsDict: dict as [String : AnyObject]?, complete: { (success:Bool,obj:Any) in
            
            complete(success,obj)
            
        }, downloadProgress:{ _ in })
    
    }
    
    /**
     *  注册
     *
     *  @param phoneNum 手机号
     *  @param veriCode 验证码
     *  @param passwd   密码
     *  @param complete 结果回调
     */
    func postRegister(phoneNum:String,veriCode:String,passwd:String,complete:@escaping NetManagerCallback){
        
        let requestUrl = "\(kBaseURL)\(kPathRegister)"
        let dict = [
            "mobile":   phoneNum,
            "password": passwd,
            "phoneimei":deviceUUID,
            "phonetype":deviceType,
            "phonesys": deviceOS,
            "version":  appVersion,
            "build":    appBuildVersion,
            "platform": iOSPlatform,
            "verificationCode":veriCode,
            TaxTaoAppIdKey:TaxTaoAppId]
        
        postRequestWithUrl(requestUrl, paramsDict: dict as [String : AnyObject]?, complete:{ (success:Bool,obj:Any) in
            
            if success {
            
                //1.返回参数判断
                let jsonDict = obj as! Dictionary<String, Any>
                let dictData = jsonDict["data"]
                if dictData is Dictionary<String,Any> {
                    
                }else{
                    complete(false,kServerReturnEmptyData)
                    return
                }
                
            
                if let dict = dictData as? Dictionary<String,Any> {
                
                    let userInfoDict = dict["account"]
                    let accessToken  = dict["accessToken"]
                    
                    guard  userInfoDict != nil else{
                        complete(false,kError_AccountInfoIsNil)
                        return
                    }
                    guard  accessToken != nil else{
                        complete(false,kError_TokenIsNil);
                        return
                    }
                    
                    //2.数据解析
                    var userInfo = YHDataParser.shareInstanced.parseUserInfo(dict: userInfoDict as! Dictionary<String, Any>, isSelf: true)
                    userInfo.accessToken = accessToken as! String?
                    complete(true,userInfo);
                    
                    
                }else{
                   complete(false,kError_NotJSONFormat)
                }

            }else{
                complete(false,obj);
            }
            
        }, uploadProgress:{_ in 
        
        })

        
    }
    
    
    //验证token是否有效(直接登录用到)
    func postValidateToken(userInfo:YHUserInfo,complete:@escaping NetManagerCallback){
        let requestUrl = "\(kBaseURL)\(kPathValidateToken)"
        let uid   = UserDefaults.standard.string(forKey: kUserUid)
        let token = UserDefaults.standard.string(forKey: kAccessToken)
        guard uid != nil else{
            complete(false,kError_UidIsNil)
            return
        }
        
        guard token != nil else{
            complete(false,kError_TokenIsNil)
            return
        }
        
        let dict = [
             "userId": uid,
             "accessToken" : token,
             TaxTaoAppIdKey: TaxTaoAppId
        ]
        
        postRequestWithUrl(requestUrl, paramsDict: dict as [String : AnyObject]?, complete: {(success:Bool ,obj:Any) in
            complete(success,obj)
        }, uploadProgress: { _ in
        
        })
    }
    
    //登录
    func postLogin(phoneNum:String,passwd:String,complete:@escaping NetManagerCallback) {
        let passwdMD5 = md5HexDigest(str: passwd)
        let dict = [
            "loginUser":phoneNum,
            "password" :passwdMD5,
            "phoneimei":deviceUUID,
            "phonetype":deviceType,
            "phonesys": deviceOS,
            "version":  appVersion,
            "build":    appBuildVersion,
            "platform": iOSPlatform,
            TaxTaoAppIdKey: TaxTaoAppId
        ]
        
        _login(requestDict: dict, complete: complete)
        
    }
    
    //短信验证码登录
    func postLogin(phoneNum:String,verifyCode:String,complete:@escaping NetManagerCallback){
        let dict = [
            "loginUser"        :phoneNum,
            "verificationCode" :verifyCode,
            "phoneimei":        deviceUUID,
            "phonetype":        deviceType,
            "phonesys":         deviceOS,
            "version":          appVersion,
            "build":            appBuildVersion,
            "platform":         iOSPlatform,
            TaxTaoAppIdKey:     TaxTaoAppId
        ]
        
        _login(requestDict: dict, complete: complete)
    }
    
    //重置密码后登录
    func postLogin(phoneNum:String,verifyCode:String,newPasswd:String,complete:@escaping NetManagerCallback) {
        let requestUrl = "\(kBaseURL)\(kPathForgetPasswd)"
        let passwdMD5  = md5HexDigest(str: newPasswd)
        let dictForget =
            ["mobile"          :phoneNum,
            "verificationCode" :verifyCode,
            "password"         :passwdMD5,
            "platform"         :iOSPlatform,
            TaxTaoAppIdKey     :TaxTaoAppId
            ] as [String : Any]
        
        postRequestWithUrl(requestUrl, paramsDict: dictForget as [String : AnyObject]?, complete: { (success:Bool,obj:Any) in
            complete(success,obj);
        }, uploadProgress: {
            _ in
        })

    }


    //批量校验手机号是否已注册
    func postVerifyPhonesAreRegistered(phoneNums:[String],complete:@escaping NetManagerCallback) {
        let requestUrl = "\(kBaseURL)\(kPathWhetherPhonesAreRegistered)"
        guard  YHUserInfoManager.shareInstanced.userInfo?.accessToken != nil else{
            complete(false,kError_TokenIsNil)
            return
        }
        guard phoneNums.count > 0 else{
            complete(false,kError_PhoneNumIsNil);
            return
        }
        
        let phones = phoneNums.joined(separator: ",")
        let dict   =  [
            "accessToken":YHUserInfoManager.shareInstanced.userInfo!.accessToken ?? "",
            "phones":phones,
            TaxTaoAppIdKey     :TaxTaoAppId
        ] as [String : Any]
        
        postRequestWithUrl(requestUrl, paramsDict: dict as [String : AnyObject]?, complete: {(success:Bool,obj:Any) in
        
            if success{
            
                //1.返回参数判断
                let jsonDict = obj as! Dictionary<String, Any>
                let dictData = jsonDict["data"]
                if dictData is Dictionary<String,Any> {
                    
                }else{
                    complete(false,kServerReturnEmptyData)
                    return
                }

                if let dict = dictData as? Dictionary<String,Any> {
                    
                    var dictRet = Dictionary<String,Any>()
                    var registerUserIds = [String]()
                    var registerUserPhoneNums = [String]()
                    
                    if let accounts  =  dict["account"] as? [Dictionary<String,Any>]{
                        
                         for i in 0..<accounts.count {
                                
                            let dictOne   = accounts[i]
                            if let userId = dictOne["id"] as? String{
                                registerUserIds.append(userId)
                            }
                            if  let userPhone = dictOne["mobile"] as? String {
                                registerUserPhoneNums.append(userPhone)
                            }
                                
                         }
                    
                    }
                    
                    dictRet = [
                        "id"    :registerUserIds,
                        "mobile":registerUserPhoneNums
                    ]
                    complete(true,dictRet);
                    
  
                }else{
                    complete(false,"not json")
                    return
                }
            
                
            }else{

                complete(false,obj)
            
            }
            
        }, uploadProgress: {
            _ in
        })

    }
    
    //验证第三方账号登录是否有效
    func postVerifyThirdPlatformAccount(uid:String,platform:PlatformType,complete:@escaping NetManagerCallback) {
        let requestUrl = "\(kBaseURL)\(kPathVerifyThridPartyAccount)"
        guard uid.isEmpty == false else{
            complete(false,kError_ThirdPlatformUidIsNil)
            return
        }
        
        //appId + uid 然后md5加密
        let composeStr = "\(TaxTaoAppId)\(uid)"
        let passwdMD5  = md5HexDigest(str:composeStr)
        let dict = [
            "identifier"   :uid,
            "identityType" :platform,
            "checkCode"    :passwdMD5,
            "platform"     :iOSPlatform,
            TaxTaoAppIdKey :TaxTaoAppId
        ] as [String : Any]
        postRequestWithUrl(requestUrl, paramsDict: dict as [String : AnyObject]?, complete: {
            (success:Bool,obj:Any) in
            
            if success {
            
                //1.返回参数判断
                let jsonDict = obj as! Dictionary<String, Any>
                let dictData = jsonDict["data"]
                if dictData is Dictionary<String,Any> {
                    
                }else{
                    complete(false,kServerReturnEmptyData)
                    return
                }
                
                if let dict = dictData as? Dictionary<String,Any> {
                    
                    let userInfoDict = dict["account"]
                    let accessToken  = dict["accessToken"]
                    
                    guard  userInfoDict != nil else{
                        complete(false,kError_AccountInfoIsNil)
                        return
                    }
                    guard  accessToken != nil else{
                        complete(false,kError_TokenIsNil);
                        return
                    }
                    
                    //2.数据解析
                    var userInfo = YHDataParser.shareInstanced.parseUserInfo(dict: userInfoDict as! Dictionary<String, Any>, isSelf: true)
                    userInfo.accessToken = accessToken as! String?
                    complete(true,userInfo);
                    
                    
                }else{
                    complete(false,kError_NotJSONFormat)
                }
 
            }else{
            
                complete(false,obj)
            }
            
            
        }, uploadProgress: {
            _ in
        })
        
    }
    
    //第三方账号登录绑定手机号
    func postBindPhone(phone:String,platform:PlatformType,thridPartyUid:String,verifyCode:String,complete:@escaping NetManagerCallback) {
        let requestUrl = "\(kBaseURL)\(kPathBindPhoneByThirdPartyAccountLogin)"
        guard phone.isEmpty == false else{
            complete(false,kError_PhoneBindedIsNil)
            return
        }
        guard verifyCode.isEmpty == false else{
            complete(false,kError_VerifyCodeIsNil)
            return
        }
        guard thridPartyUid.isEmpty == false else{
            complete(false,kError_ThirdPlatformUidIsNil)
            return
        }
        
        //appId + uid 然后md5加密
        let composeStr = "\(TaxTaoAppId)\(thridPartyUid)"
        let passwdMD5  = md5HexDigest(str:composeStr)
        let dict = [
            "mobile":phone,
            "verificationCode":verifyCode,
            "identifier":thridPartyUid,
            "identityType":platform,
            "platform":iOSPlatform,
            "checkCode":passwdMD5,
            TaxTaoAppIdKey:TaxTaoAppId
        ] as [String : Any]
        
        postRequestWithUrl(requestUrl, paramsDict: dict as [String : AnyObject]?, complete: {
            (success:Bool,obj:Any) in
            
            if success {
                
                //1.返回参数判断
                let jsonDict = obj as! Dictionary<String, Any>
                let dictData = jsonDict["data"]
                if dictData is Dictionary<String,Any> {
                    
                }else{
                    complete(false,kServerReturnEmptyData)
                    return
                }
                
                if let dict = dictData as? Dictionary<String,Any> {
                    
                    let userInfoDict = dict["account"]
                    let accessToken  = dict["accessToken"]
                    
                    guard  userInfoDict != nil else{
                        complete(false,kError_AccountInfoIsNil)
                        return
                    }
                    guard  accessToken != nil else{
                        complete(false,kError_TokenIsNil);
                        return
                    }
                    
                    //2.数据解析
                    var userInfo = YHDataParser.shareInstanced.parseUserInfo(dict: userInfoDict as! Dictionary<String, Any>, isSelf: true)
                    userInfo.accessToken = accessToken as! String?
                    complete(true,userInfo);
                    
                    
                }else{
                    complete(false,kError_NotJSONFormat)
                }
                
            }else{
                
                complete(false,obj)
            }

        }, uploadProgress: {
            _ in
        })
        
        
    }
    
    //第三方绑定手机后设置密码
    func postThridPartyLoginAndSetPasswd(passwd:String,complete:@escaping NetManagerCallback) {
        
        let requestUrl = "\(kBaseURL)\(kPathThridPartyLoginSetPasswd)"
        guard passwd.isEmpty == false else{
            complete(false,kError_PasswdIsNil)
            return
        }
        
        guard YHUserInfoManager.shareInstanced.userInfo?.accessToken?.isEmpty == false else{
            complete(false,kError_TokenIsNil)
            return
        }
        
        let passwdMD5 = md5HexDigest(str:passwd)
        let dict = [
            "accessToken":YHUserInfoManager.shareInstanced.userInfo?.accessToken,
            "password":passwdMD5
        ]
        
        postRequestWithUrl(requestUrl, paramsDict: dict as [String : AnyObject]?, complete: {
            (sucess:Bool,obj:Any) in
            complete(sucess,obj)
        }, uploadProgress: {
            _ in
        })
        
    }
    
    
    // MARK: - Private
    fileprivate func _login(requestDict:Dictionary<String,Any>,complete:@escaping NetManagerCallback) {
        let requestUrl = "\(kBaseURL)\(kPathLogin)"
        
        postRequestWithUrl(requestUrl, paramsDict: requestDict as [String : AnyObject]?, complete: {(success:Bool,obj:Any) in
            
            if success{
                //1.返回参数判断
                let jsonDict = obj as! Dictionary<String, Any>
                let dictData = jsonDict["data"]
                if dictData is Dictionary<String,Any> {
                    
                }else{
                    complete(false,kServerReturnEmptyData)
                    return
                }
                
                if let dict = dictData as? Dictionary<String,Any> {
                    
                    let userInfoDict = dict["account"]
                    let accessToken  = dict["accessToken"]
                    
                    guard  userInfoDict != nil else{
                        complete(false,kError_AccountInfoIsNil)
                        return
                    }
                    guard  accessToken != nil else{
                        complete(false,kError_TokenIsNil);
                        return
                    }
                    
                    //2.数据解析
                    var userInfo = YHDataParser.shareInstanced.parseUserInfo(dict: userInfoDict as! Dictionary<String, Any>, isSelf: true)
                    userInfo.accessToken = accessToken as! String?
                    complete(true,userInfo);
                    
                    //3.更新UserInfoManager
                    YHUserInfoManager.shareInstanced.loginSuccess(userInfo: userInfo)
                }else{
                    complete(false,kError_NotJSONFormat)
                }

                
            }else{
                complete(false,obj)
            }
            
        }, uploadProgress: { _ in
        
        })
    }
    
    //退出登录
    func postLogout(complete:@escaping NetManagerCallback){
        let requestUrl = "\(kBaseURL)\(kPathLogout)"
        
        guard YHUserInfoManager.shareInstanced.userInfo?.accessToken?.isEmpty == false else{
            complete(false,kError_TokenIsNil)
            return
        }
        
        let  dict = [
            "accessToken":YHUserInfoManager.shareInstanced.userInfo?.accessToken,
            TaxTaoAppIdKey:TaxTaoAppId
        ]
        
        postRequestWithUrl(requestUrl, paramsDict: dict as [String : AnyObject]?, complete: {
            (success:Bool,obj:Any) in
            YHUserInfoManager.shareInstanced.logout()
            complete(success,obj)
        }, uploadProgress: {
            _ in
        })
        
    }
    
    
}
