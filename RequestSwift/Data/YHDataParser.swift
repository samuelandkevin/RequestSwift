//
//  YHDataParser.swift
//  RequestSwift
//
//  Created by YHIOS002 on 16/12/14.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation

class YHDataParser {
    
    static let shareInstanced = YHDataParser()
    
    /******解析用户信息 *****/
    func parseUserInfo(dict:Dictionary<String,Any>,isSelf:Bool) -> YHUserInfo {
        
        var userInfo = YHUserInfo()
        userInfo.isSelfModel     = isSelf
        userInfo.isRegister      = true
        userInfo.uid             = dict["id"] as? String
        userInfo.mobilephone     = dict["mobile"] as? String
        userInfo.userName        = dict["name"] as? String
        userInfo.province        = dict["province"] as? String
        userInfo.workCity        = dict["city"] as? String
        userInfo.taxAccount      = dict["userName"] as? String
        let dynamicCount = dict["dynamic_count"] as? Int
        userInfo.dynamicCount    = (dynamicCount != nil) ? dynamicCount! : 0
        userInfo.visitTime       = dict["visitor_time"] as? String
        
        if let jobTagsString  = dict["workMark"] as? String{
             let jobTags = jobTagsString.components(separatedBy: ",")
             userInfo.jobTags = jobTags
        }

        userInfo.workLocation    = dict["location"] as? String
        userInfo.intro       = dict["description"] as? String
        if let strAvatar  = dict["profileImageUrl"] as? String {
            userInfo.avatarUrl = URL(string: strAvatar)
        }

        userInfo.company     = dict["company"] as? String
        userInfo.job         = dict["job"] as? String
        userInfo.industry    = dict["indusry"] as? String
        if  let _ = dict["gender"] as? Bool{
            userInfo.sex         = 1
        }else {
            userInfo.sex         = 0
        }
        
        userInfo.loginTime   = dict["createdDate"] as? String
        if let workExp = dict["professional"] as? [Dictionary<String,Any>] {
            userInfo.workExperiences = parseWorkExp(workExp: workExp)
        }
        
        if let eduExp = dict["education"] as? [Dictionary<String,Any>] {
            userInfo.eductaionExperiences = parseEduExp(eduExp: eduExp)
        }

        if let fansCount = dict["focusCount"] as? Int{
            userInfo.fansCount     = fansCount
        }
        
        if let isFollowed = dict["isFocus"] as? Bool {
            userInfo.isFollowed    = isFollowed
        }
        
        if let friShipStatus = dict["friendStatus"] as? Int {
            if friShipStatus == 1 {
                 userInfo.friShipStatus = .isMyFriend
            }else if friShipStatus == 2{
                 userInfo.friShipStatus = .reject
            }
        }

        let addFriStauts = dict["is_sqf"] as? String
        if addFriStauts?.isEmpty == false {
               let type = Int(addFriStauts!)
            if type == 0 {
                userInfo.addFriStatus =  .otherPersonAddMe
            }else if type == 1{
                userInfo.addFriStatus =  .iAddOtherPerson
            }
        }
        
        if let identity = dict["type"] as?Int {
            if identity == 1{
                userInfo.identity = .bigName
            }
        }
        
        return userInfo
    }
    
    //解析工作经历
    func parseWorkExp(workExp:[Dictionary<String,Any>]) -> [YHWorkExperienceModel] {
        
        var maWorkExp = [YHWorkExperienceModel]()
        for  i  in 0..<workExp.count {
            let dict = workExp[i]
            if  dict.isEmpty == false{
                var model = YHWorkExperienceModel()
                model.position          = dict["job"] as? String
                model.company           = dict["company"] as? String
                model.beginTime         = dict["startDate"] as? String
                model.endTime           = dict["endDate"] as? String
                model.workExpId         = dict["id"] as? String
                model.moreDescription   = dict["description"] as? String
                maWorkExp.append(model)
            }
        }
        
        if maWorkExp.count >= 2 {
    
              maWorkExp =  maWorkExp.sorted( by: { (obj1, obj2) -> Bool in
                    
                    if let beginDate = obj1.endTime, let endDate = obj2.beginTime {
                         return  compareDate(beginDate:beginDate, endDate: endDate)
                    }
                    return false
            })
        }
        return maWorkExp
    
    }
    
    //解析教育经历
    func parseEduExp(eduExp:[Dictionary<String,Any>]) -> [YHEducationExperienceModel] {
        
        var maEduExp = [YHEducationExperienceModel]()
        for  i  in 0..<eduExp.count {
            let dict = eduExp[i]
            if  dict.isEmpty == false{
                var model = YHEducationExperienceModel()
                model.school            = dict["university"] as? String
                model.major             = dict["major"] as? String
                model.educationBackground   = dict["degree"] as? String
                model.beginTime         = dict["startDate"] as? String
                model.endTime           = dict["endDate"] as? String
                model.eduExpId          = dict["id"] as? String
                model.moreDescription   = dict["description"] as? String
                maEduExp.append(model)
            }
        }
        
        if maEduExp.count >= 2 {
            
            maEduExp =  maEduExp.sorted( by: { (obj1, obj2) -> Bool in
                
                if let beginDate = obj1.endTime, let endDate = obj2.beginTime {
                    return  compareDate(beginDate:beginDate, endDate: endDate)
                }
                return false
            })
        }
        return maEduExp
        
    }
    
    
    
    
}
