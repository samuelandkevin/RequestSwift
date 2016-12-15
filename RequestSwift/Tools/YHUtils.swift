//
//  YHUtils.swift
//  RequestSwift
//
//  Created by YHIOS002 on 16/12/14.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation
import UIKit




let infoDic = Bundle.main.infoDictionary
// MARK: 获取App的版本
let appVersion = infoDic?["CFBundleShortVersionString"]
// MARK: 获取App的build版本
let appBuildVersion = infoDic?["CFBundleVersion"]
// MARK: 获取App的名称
let appName = infoDic?["CFBundleDisplayName"]
// MARK: 获取设备系统
let deviceOS = "\(UIDevice.current.systemName)\(UIDevice.current.systemVersion)"
// MARK: 获取设备UUID
let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
// MARK: 获取设备型号
let deviceType = UIDevice.current.modelName


struct YHUtils {
   
}

// MARK: 日期比较
func compareDate(beginDate:String,endDate:String) -> Bool{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM"
    let bDate = dateFormatter.date(from: beginDate)
    let eDate = dateFormatter.date(from: endDate)
    if bDate != nil && eDate != nil {
        let result = bDate!.compare(eDate!)
        if result == .orderedAscending {
            return true
        }
        return false
    }
    return false
}

func md5HexDigest(str:String) -> String{
    let cStr = str.cString(using: .utf8);
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
    CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
    let md5String = NSMutableString();
    for i in 0 ..< 16{
        md5String.appendFormat("%02x", buffer[i])
    }
    free(buffer)
    return md5String as String
}

