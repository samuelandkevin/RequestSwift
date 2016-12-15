//
//  YHUserInfo.swift
//  RequestSwift
//
//  Created by YHIOS002 on 16/12/14.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation
import UIKit

enum UpdateStatus {
    case finish
    case failure
}

//好友状态
enum FriendShipStatus {
    case notpassValidtion//未通过验证
    case isMyFriend      //是我的好友
    case reject          //已拒绝
}

//添加好友的状态 (服务器返回：0 别人申请加我为好友 1 我申请加别人为好友  ->解析后 自定义101 别人申请加我为好友 102 我申请加别人为好友)
enum AddFriendStatus {
    case none
    case otherPersonAddMe //别人申请加我为好友
    case iAddOtherPerson  //我申请加别人为好友

}

//身份类型
enum IdentityOption {
    case normal   //普通用户
    case bigName  //大咖
}


struct YHUserInfo{
    
    var isSelfModel:Bool = false   //用户Model是当前用户还是客人
    var isRegister:Bool  =  false  //是否已注册,判断是否是游客
    var updateStatus:UpdateStatus = .failure
    var uid:String? = nil
    var accessToken:String? = nil //令牌
    var taxAccount:String?  = nil //税道账号
    var mobilephone:String? = nil //手机号  （可以用手机号/税道账号来登录）
    var userName:String?  = nil   //姓名
    var sex:Int    = 1          // 1-男， 0-女
    var avatarUrl:URL?    = URL(string: "")     //用户头像缩略图URL
    var oriAvaterUrl:URL? = URL(string: "")     //用户头像原图URL
    var intro:String?     = nil    //个人简介
    var industry:String?  = nil    //行业职能
    var job:String?       = nil    //职位
    var province:String?  = nil    //省份
    var workCity:String?  = nil    //工作城市
    var workLocation:String?  = nil//工作地点
    var loginTime:String? = nil    //登录时间
    var company:String?   = nil    //公司名称
    var email:String?     = nil    //电邮
    var dynamicCount:Int = 0     //动态数量
    var visitTime:String? = nil    //访问时间
    /**
     *  用户头像，用strong因为修改头像时要保存引用
     */
    var avatarImage:UIImage? = UIImage()
    var fromType:Int     = 0    //来自哪个平台
    var isOfficial:Bool  = false//官方账号
    var nNewFansCount:Int = 0    //新粉丝数量
    var fansCount:Int    = 0    //粉丝数量
    var followCount:Int  = 0    //关注的人数量
    var likeCount:Int    = 0    //点赞数量
    
    var identity:IdentityOption = .normal //身份类型
    var friShipStatus:FriendShipStatus = .notpassValidtion        //好友关系状态
    var addFriStatus:AddFriendStatus  = .none        //添加好友的状态   (服务器返回：0 别人申请加我为好友 1 我申请加别人为好友  ->解析后 自定义101 别人申请加我为好友 102 我申请加别人为好友)
    var isFollowed:Bool     = false  //已经被关注
    var photoCount:Int      = 0      //用户照片数量
    var photoAlbum:[UIImage]? = []    //相册
    
    var jobTags:[String]? = []        //职位标签
    
    var  workExperiences:[YHWorkExperienceModel] = []           //工作经历
    var  eductaionExperiences:[YHEducationExperienceModel] = [] //教育经历
    
    
}

struct YHWorkExperienceModel {
    
    var workExpId:String? = ""
    var company:String?   = ""
    var position:String?  = ""
    var beginTime:String? = ""
    var endTime:String?   = ""
    var moreDescription:String? = ""
    
}

struct YHEducationExperienceModel {
    
    var eduExpId:String? = ""
    var school:String?   = ""
    var major:String?    = ""
    var educationBackground:String? = ""
    var beginTime:String? = ""
    var endTime:String?  = ""
    var moreDescription:String? = ""
    
}


