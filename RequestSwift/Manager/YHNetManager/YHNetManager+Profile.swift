//
//  YHNetManager+Profile.swift
//  RequestSwift
//
//  Created by YHIOS002 on 16/12/15.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation
import UIKit

extension YHNetManager {
    
    //获取我的名片信息
    func getMyCardDetail(complete:@escaping NetManagerCallback){
        let requestUrl = "\(kBaseURL)\(kPathMyCard)"
        
        //参数判断
        guard  YHUserInfoManager.shareInstanced.userInfo?.accessToken != nil else{
            complete(false,kError_TokenIsNil)
            return
        }
        guard  YHUserInfoManager.shareInstanced.userInfo?.uid != nil else{
            complete(false,kError_UidIsNil)
            return
        }
        
        let dict = [
            "accessToken":YHUserInfoManager.shareInstanced.userInfo?.accessToken,
            "userId":YHUserInfoManager.shareInstanced.userInfo?.uid
        ]
        
        getRequestWithUrl(requestUrl, paramsDict: dict as [String : AnyObject]?, complete: {
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
                    
                    guard  userInfoDict != nil else{
                        complete(false,kError_AccountInfoIsNil)
                        return
                    }

                    //2.数据解析
                    var userInfo = YHDataParser.shareInstanced.parseUserInfo(dict: userInfoDict as! Dictionary<String, Any>, isSelf: true)
                    let accessToken = UserDefaults.standard.string(forKey: kAccessToken)
                    userInfo.accessToken = accessToken
                    complete(true,userInfo);
                }else{
                    complete(false,kError_NotJSONFormat)
                }
                
               
                
            }else{
            
                complete(false,obj)
            }
            
        }, downloadProgress: {_ in})
        
    }
    
    
    /**
     *  上传头像
     *
     *  @param image    头像Image
     *  @param complete 成功失败回调
     *  @param progress 上传进度回调
     */
    func postUploadImage(image:UIImage,complete:@escaping NetManagerCallback,progress:@escaping YHUploadProgress){
        

        let requestUrl = "\(kBaseURL)\(kPathUploadImage)"
    
        uploadRequestWithUrl(url: requestUrl, paramsDict: nil, imageArray: [image], fileNames:["myAvatar"], name:"files", mimeType:"image/png", progress: {
            (bytesWritten:Int64,totalBytesWritten:Int64) in
            progress(bytesWritten,totalBytesWritten)
            
        }, complete: {
            (success:Bool,obj:Any) in
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
                    
                    var avtarUrl  = URL(string: "")
                    if let arrayPics = dict["pics"] as? [Dictionary<String,Any>] {
                        let dict2 =  arrayPics[0] as Dictionary<String,Any>
                        if let urlString = dict2["picUrl"] as? String{
                            avtarUrl = URL(string:urlString )
                        }
                        
                        complete(true,avtarUrl ?? "")
                    }else{
                        complete(false,kError_NotJSONFormat)
                    }
                    
                }else{
                     complete(false,kError_NotJSONFormat)
                }
                
            }else{
                complete(false,obj)
            }
        })
        
    }
    
    //编辑我的名片
    func postEditMyCard(userInfo:YHUserInfo,complete:@escaping NetManagerCallback)  {
        let requestUrl = "\(kBaseURL)\(kPathEditMyCard)"
        
        guard  YHUserInfoManager.shareInstanced.userInfo?.accessToken != nil else{
            complete(false,kError_TokenIsNil)
            return
        }
        
        guard  YHUserInfoManager.shareInstanced.userInfo?.uid != nil else{
            complete(false,kError_UidIsNil)
            return
        }
        
        //2-1.必要参数
        let requiredDict = [
            "accessToken":YHUserInfoManager.shareInstanced.userInfo?.accessToken,
            "userId":YHUserInfoManager.shareInstanced.userInfo?.uid
        ]
        
        var params = requiredDict
        
        //3.设置可选参数
        if  userInfo.userName != nil {
            params["username"] = userInfo.userName
        }
        if  userInfo.sex > 0 {
            params["gender"] = String(userInfo.sex)
        }
        if  userInfo.workCity != nil {
            params["workCity"] = userInfo.workCity
        }
        if userInfo.workLocation != nil {
            params["workLocation"] = userInfo.workLocation
        }
        if userInfo.industry != nil {
             params["workAt"] = userInfo.industry
        }
        if userInfo.company != nil {
            params["company"] = userInfo.company
        }
        if userInfo.job != nil {
            params["job"] = userInfo.job
        }

        if let jobTags = userInfo.jobTags {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: jobTags, options: [])
                let strJobTags = String.init(data: data, encoding: .utf8)
                params["workMark"]  = strJobTags
            }catch{
                complete(false,"jobTags convert to data fail")
                return
            }
           
        }

        if userInfo.avatarUrl != nil {
            if let urlstring = userInfo.avatarUrl?.absoluteString {
                params["profileImage"] = urlstring
            }else{
                complete(false,"userInfo avatarUrl is nil");
                return
            }
        }
        
        if userInfo.intro != nil {
            params["description"] = userInfo.intro
        }

        postRequestWithUrl(requestUrl, paramsDict: params as [String : AnyObject]?, complete: {
            (success:Bool,obj:Any) in
            complete(success,obj)
        }, uploadProgress:{_ in 
            
        } )
   
    
    }
    

}
