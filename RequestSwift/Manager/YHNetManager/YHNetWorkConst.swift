//
//  YHNetWorkConst.swift
//  RequestSwift
//
//  Created by YHIOS002 on 16/12/13.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation

let kSuccessCode = "999"  //请求成功状态码
let iOSPlatform  = "1"    //iOS平台
let kParseError  = "json 解析失败"
let kReqTimeOutInterval = 20            //请求超时时间
let kServerReturnEmptyData = "返回空数据" //服务器返回空数据
let kNetWorkFailTips =  "网络链接失败,请检查网络设置"//断网提示
let kNetWorkReqTimeOutTips = "请求超时,请稍后重试"  //请求超时提示

//所有公共服务的接口都必须传递 “app_id”:
let TaxTaoAppId = "6f76a5fbf03a412ebc7ddb785d1a8b10"//税道APPId
let TaxTaoAppIdKey = "app_id"


/*******网络请求回调*****/
typealias NetManagerCallback = (_ success:Bool,_ obj:Any) -> Void

/** 上传进度回调
 *  @param bytesWritten      已上传的大小
 *  @param totalBytesWritten 总上传大小
 */
typealias YHUploadProgress = (_ bytesWritten:Int64,_ totalBytesWritten:Int64) -> Void

/******进度回调***/
typealias YHProgress = (_ progress:Progress) -> Void

/******网络状态变化回调***/
typealias YHNetWorkStatusChange = (_ status:YHNetworkStatus) -> Void





/******请求类型*******/
enum YHNetWorkType:Int {
    case get, post, delegate
}

/******网络状态类型****/
enum YHNetworkStatus:Int ,CustomStringConvertible{
    case unknown = -1
    case notReachable
    case reachableViewWWAN
    case reachableViaWiFi
    
    var description: String{
        switch self {
        case .unknown: return "未知网络"
        case .notReachable: return "没有网络"
        case .reachableViewWWAN: return "手机自带网络"
        case .reachableViaWiFi: return "WIFI"
        
        }
    }
}


//登录的平台
enum PlatformType:Int{
    case fromQQ = 0
    case fromWechat
    case fromSina
}

