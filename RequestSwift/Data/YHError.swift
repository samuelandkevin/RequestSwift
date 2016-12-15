//
//  YHError.swift
//  RequestSwift
//
//  Created by YHIOS002 on 16/12/15.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation


// MARK: - 用户登录错误信息
let kError_TokenIsNil = "userToken is nil"
let kError_PasswdIsNil = "passwd is nil"
let kError_AccountInfoIsNil = "userAccount is nil"
let kError_NotJSONFormat = "is not json format"
let kError_PhoneBindedIsNil = "phone which is binded is nil"
let kError_VerifyCodeIsNil = "verifyCode is nil"
let kError_ThirdPlatformUidIsNil = "thridPlatformUid is nil"
let kError_PhoneNumIsNil = "phone number is nil"
let kError_UidIsNil = "uid is nil"
let kError_VerifyCode_WrongCount = "verificationCode.wrongCount"


// MARK: - 服务器返回字段
let kRetCode = "code"  //服务器返回的代码 key
let kRetMsg  = "msg"   //服务器返回的描述 key

