//
//  YHProtocolConfig.swift
//  PikeWay
//
//  Created by YHIOS002 on 16/12/9.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation

/***********BaseUrl***************************/
//let kBaseURL =  "http://192.168.1.80"   //内网测试环境
let kBaseURL = "https://testapp.gtax.cn"  //外网测试
//let kBaseURL =  "https://apps.gtax.cn"   //外网生产环境

//let kBaseURL = "http://192.168.2.251:8085"//后台家学
//let kBaseURL = "http://192.168.2.175:8080"//后台啊亮

//首页url
let pathTaxHome :String  = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathTaxHome2)"
    
    return string
}()

//案例首页
let pathCaseHome :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathCaseHome)"
    
    return string
}()

//搜索案例
let pathCaseSearch :String = {
    
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathCaseSearch)"
    
    return string
}()


//法规库
let pathLawLib :String = {
    
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathLawLib)"
    
    return string
}()

//微信支付详情
let pathWechatPayDetail :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathWechatPayDetail)"
    
    return string
}()

//人才首页
let pathTalentHome :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: true)) + \(kPathTalentHome)"
    
    return string
}()


//悬赏首页
let pathRewardHome :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: true)) + \(kPathRewardHome)"
    
    return string
}()


//发悬赏
let pathSendReward :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathSendReward)"
    
    return string
}()


//双人聊界面
let pathChatDetail :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathChatDetail)"
    
    return string
}()



//群列表
let pathGroupList :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathGroupList)"
    
    return string
}()


//群设置
let pathGroupSetting :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathGroupSetting)"
    
    return string
}()


//群聊界面
let pathGroupChat :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathGroupChat)"
    
    return string
}()


//聊天列表
let pathChatList :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathChatList)"
    
    return string
}()


//搜索的首页
let pathSearchHome :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathSearchHome)"
    
    return string
}()


//咨讯首页
let pathNewsHome :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathNewsHome)"
    
    return string
}()


//我的钱包
let pathMyWallet :String = {
    let string = "\(YHProtocolConfig.shareInstanced.getBaseUrlLoadByHTTPS(loadByHTTPS: false)) + \(kPathMyWallet)"
    
    return string
}()



/**********登录注册*************/
let kPathVerifyPhoneExist = "/app_core_api/v1/account/verification_mobile";//验证手机号码是否已注册
let kPathRegister         = "/app_core_api/v1/account/regist";             //注册
let kPathValidateToken    = "/app_core_api/v1/account/check_token";        //token是否有效
let kPathLogin            = "/app_core_api/v1/account/login";              //登录
let kPathForgetPasswd     = "/app_core_api/v1/account/forget_password";    //忘记密码
let kPathLogout           = "/app_core_api/v1/account/logout";             //退出登录
let kPathWhetherPhonesAreRegistered = "/app_core_api/v1/account/verifyPhonesIsReg";//批量校验手机号是否已注册
let kPathVerifyThridPartyAccount = "/app_core_api/v1/account/authenticate";//验证第三方账号登录有效性
let kPathBindPhoneByThirdPartyAccountLogin = "/app_core_api/v1/account/bind_authenticate";//通过第三方登录绑定手机号
let kPathThridPartyLoginSetPasswd = "/app_core_api/v1/account/reset_password";   //第三方绑定手机后设置密码



/**********工作圈**********/
let kPathSendDynamic      = "/taxtao/api/dynamics/public";   //发布动态
let kPathWorkGroupDynamicList = "/taxtao/api/dynamics/public_timeline";    //获取工作圈动态列表
let kPathWorkGroupDynamicListByTag = "/taxtao/api/dynamics/public_timeline_by_type";//按标签获取工作圈动态列表
let kPathCommentDynamic   = "/taxtao/api/comments/create";  //评论动态
let kPathLikeDynamic      = "/taxtao/api/attitude/click" ;  //赞某条动态
let kPathDynamicCommentList = "/taxtao/api/comments/show";    //获取某一条动态的评论列表
let kPathDynamicLikeList   = "/taxtao/api/attitude/show";    //获取某一条动态的点赞列表
let kPathDynamicRepost     = "/taxtao/api/dynamics/repost";  //转发某一条动态
let kPathDeleteDynamicComment = "/taxtao/api/comments/destroy"; //删除某一条评论
let kPathGetDynamciDetail  = "/taxtao/api/dynamics/find_dynamic";   //获取动态详情页
let kPathSearchDynamic     = "/taxtao/api/dynamics/search";         //搜索动态
let kPathSynthesisSearch   = "/taxtao/api/search/complex_search"; //综合搜索
let kPathReplyComment      = "/taxtao/api/comments/reply";          //回复评论




/**********发现************/
let kPathGetBigNamesList   = "/taxtao/api/account/list_daka";//获取大咖列表
let kPathBigNameDynamics   = "/taxtao/api/dynamics/daka_dynamic";//获取大咖动态
let kPathFollowBigName     = "/taxtao/api/focus/focus_daka"; //关注(取消关注）大咖
let kPathChangeIdentify    = "/taxtao/api/account/change_user_type";//身份转变
let kPathFindLaws          = "/taxtao/api/lawlib/search";  //找法规






/**********人脉************/
let kPathNewFriends       = "/taxtao/api/friendships/new_friends";    //获取新的好友
let kPathMyFriends        = "/taxtao/api/friendships/friends";        //我的好友
let kPathAddFriend        = "/taxtao/api/friendships/create";         //添加好友
let kPathDeleteFriend     = "/taxtao/api/friendships/delete";         //删除好友
let kPathVisitCardDetail  = "/taxtao/api/account/visit";              //访问名片详情
let kPathRelationWithMe   = "/taxtao/api/friendships/analysis_friendships";//其他用户与我的关系查询
let kPathAcceptAddFriendReq  = "/taxtao/api/friendships/acceptFriend";//接受加好友请求
let kPathFindFriends      = "/app_core_api/v1/account/findFriends";//查找朋友
let kPathGetUserAccount   = "/app_core_api/v1/account/my_account"; //获取用户账号信息（手机号和税道账号）
let kPathSearchConnection = "/taxtao/api/account/search"; //人脉搜索








/************我***********/

let kPathTaxAccountExist  = "/app_core_api/v1/account/verification_username";//验证税道账号是否存在
let kPathEditMyCard       = "/taxtao/api/account/edit";           //修改我的名片
let kPathMyCard           = "/taxtao/api/account/my_account";          //我的名片
let kPathModifyPasswd     = "/app_core_api/v1/account/change_password";//修改密码
let kPathGetMyDynamics    = "/taxtao/api/dynamics/my_dynamic";     //获取我的动态
let kPathGetFriDynamics   = "/taxtao/api/dynamics/friendship_dynamic";//获取好友的动态
let kPathGetMyVistors     = "/taxtao/api/friendships/visitors";    //获取我的访客
let kPathUploadImage      = "/taxtao/api/images/uploads";          //上传图片
let kPathValidateOldPasswd = "/app_core_api/v1/account/verification_pasword";                                           //验证旧密码是否正确
let kPathChangePhone      = "/app_core_api/v1/account/change_mobile";    //更改手机号码
let kPathChangeTaxAccount = "/app_core_api/v1/account/change_username";  //更改税道账号
let kPathGetAppInfo       = "/app_core_api/v1/appBaseInfo";              //获取应用基本信息
let kPathCheckUpdate      = "/app_core_api/v1/checkUpgrade";             //检查更新
let kPathGetAbout         = "/app_core_api/v1/bootstrap";                 //获取关于内容
let kPathIndustryList     = "/taxtao/api/industry/list";                     //获取行业职位列表
let kPathEditJobTags      = "/taxtao/api/account/jobLable";                 //编辑职位标签
let kPathEditWorkExp      = "/taxtao/api/account/workExp";                  //编辑工作经历
let kPathEditEducationExp = "/taxtao/api/account/eduExp";                   //编辑教育经历
let kPathDeleteMyDynamic  = "/taxtao/api/dynamics/destroy";//删除我的动态


/************App基本信息***********/
let kPathPageCanOpened = "/app_core_api/v1/app_function";//获取页面能否打开



/**********聊天***************/
let kPathCreatGroupChat = "/taxtao/api/im/create_chat_group";//创建群聊
let kPathAddGroupMember = "/taxtao/api/im/add_chat_group";//添加群成员


/**********悬赏***************/
let kPathUpdateRewardStatus = "/taxtao/api/reward/update_payment_status";


/**********网页路径*************/
let kPathTaxHome  = "/taxtao/index"; //税道首页
let kPathTaxHome2 = "/taxtao/index_new";//税道首页2
let kPathCaseHome = "/tax/sd/case"; //案例首页
let kPathCaseSearch = "/tax/sd/case/search";//案例搜索
let kPathLawLib   = "/taxtao/lawlib/search?";//法规库
let kPathWechatPayDetail = "/wxpay_demo/wxPay";//支付详情
let kPathTalentHome = "/talente/sd/hottalent/list";//人才首页
let kPathRewardHome = "/taxtao/building";//悬赏首页
let kPathSendReward = "/taxtao/reward/public_reward";//发悬赏
let kPathChatDetail = "/taxtao/webim/chat_mobile";//聊天详情页
let kPathGroupList = "/taxtao/webim/group_list";//群列表
let kPathGroupSetting = "/taxtao/webim/group_info";//群设置
let kPathGroupChat = "/taxtao/webim/chat_group_mobile";//群聊界面
let kPathChatList = "/taxtao/webim/list";//聊天列表
let kPathSearchHome = "/taxtao/search";//搜索的首页
let kPathNewsHome = "/tax/sd/ygz";//资讯首页
let kPathMyWallet = "/taxtao/myWallet";//我的钱包



struct YHProtocolConfig {
    
    static let shareInstanced = YHProtocolConfig()
    
    
    func getBaseUrlLoadByHTTPS(loadByHTTPS:Bool) -> String {
        
        var baserUrl = kBaseURL;
        if loadByHTTPS == false  {
        
            if baserUrl.hasPrefix("https") {
                baserUrl = baserUrl.replacingOccurrences(of: "https", with: "http")
            }
            
        }else{
            if baserUrl.hasPrefix("https") == false  {
                 baserUrl = baserUrl.replacingOccurrences(of: "http", with: "https")
            }
        }
        return baserUrl
        
    }
}



