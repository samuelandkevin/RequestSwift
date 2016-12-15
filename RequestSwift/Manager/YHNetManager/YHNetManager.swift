//
//  NetManager.swift
//  PikeWay
//
//  Created by YHIOS002 on 16/12/9.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

import Foundation
import Alamofire


class YHNetManager {
    
    static let shareInstanced = YHNetManager()
    
    var requestManager : SessionManager {
        let rM = SessionManager.default
        
        return rM
    }
    
    //网络监听
    let reachablityManager = NetworkReachabilityManager(host: "www.baidu.com")
    
    //当前网络状态
    var currentNetWorkStatus:YHNetworkStatus = .unknown
    var netWorkStatusChange:YHNetWorkStatusChange?
    
    //回调时数据是否NSString类型
    func isStringClass(a:Any) -> String{
        return (a is String ) ? (a as! String) : ""
    }
    
    
    //初始化网络状态
    private func _initNetWorkStatus(){
        
        _ = self.reachablityManager?.networkReachabilityStatus
      
     
//        switch status {
//  
//        case  .unknown:
//            print("当前网络为:未知网络")
//            self.currentNetWorkStatus = YHNetworkStatus.unknown
//            
//        case .notReachable:
//            print("没有网络")
//            self.currentNetWorkStatus = YHNetworkStatus.notReachable
//            
//        case .reachable(let value) :
//            switch value {
//            case .ethernetOrWiFi:
//                print("当前网络为:WIFI")
//                self.currentNetWorkStatus = YHNetworkStatus.reachableViaWiFi
//            default:
//                print("当前网络为:手机自带网络");
//                self.currentNetWorkStatus = YHNetworkStatus.reachableViewWWAN
//            }
//        }

        
    }
    
    // MARK: - Public 网络状态
    func startMonitoring() {
        self._initNetWorkStatus()
        self.reachablityManager?.listener = { [unowned self] status in
            
            switch status {
            case .unknown:
                print("当前网络为:未知网络")
                self.currentNetWorkStatus = YHNetworkStatus.unknown
                
            case .notReachable:
                print("没有网络")
                self.currentNetWorkStatus = YHNetworkStatus.notReachable
                
            case .reachable(let value) :
                switch value {
                case .ethernetOrWiFi:
                    print("当前网络为:WIFI")
                    self.currentNetWorkStatus = YHNetworkStatus.reachableViaWiFi
                default:
                    print("当前网络为:手机自带网络");
                    self.currentNetWorkStatus = YHNetworkStatus.reachableViewWWAN
                }
            }
            
            if self.netWorkStatusChange != nil {
                self.netWorkStatusChange!(self.currentNetWorkStatus)
            }
            
        }
        self.reachablityManager?.startListening()
    }
    

    func netWorkStatusChange(netWorkStatusChange:@escaping YHNetWorkStatusChange){
        self.netWorkStatusChange = netWorkStatusChange
    }
    
    // MARK: - Public 请求方式
    //get请求
    public func getRequestWithUrl(_ url:String,paramsDict:[String:AnyObject]?,complete:@escaping NetManagerCallback,downloadProgress:YHProgress) {
        
        if(self.currentNetWorkStatus == .notReachable){
            complete(false,kNetWorkFailTips);
            downloadProgress(Progress());
            return;
        }
        
        Alamofire.request(url, method: .get, parameters: paramsDict)
            .responseJSON {[unowned self] (response) in/*这里使用了闭包*/
                
                switch response.result {
                case .success:
                   
                    var jsonDict:Dictionary<String, Any> = Dictionary()
                    
                    if self.canParseResponseObject(responseObject: response.data, jsonDict: &jsonDict){
                        
                        let reqRet = self.isRequestSuccessWithJsonDict(jsonDict: jsonDict)
                        complete(reqRet,jsonDict)
                        
                    }else{
                        
                        complete(false,kParseError);
                        
                    }
                    
                case .failure(let error):
                   
                    complete(false,error);
                }
                
                
                
        }
        
    }
    
    //post请求
    func postRequestWithUrl(_ url:String,paramsDict:[String:AnyObject]?,complete:@escaping NetManagerCallback,uploadProgress:YHProgress) {
        
        if(self.currentNetWorkStatus == .notReachable){
            complete(false,kNetWorkFailTips);
            uploadProgress(Progress());
            return;
        }
        
        Alamofire.request(url, method: .post, parameters: paramsDict).responseJSON { [unowned self](response) in
            
            switch response.result {
                case .success:
                    var jsonDict:Dictionary<String, Any> = Dictionary()
                    
                    if self.canParseResponseObject(responseObject: response.data, jsonDict: &jsonDict){
                        
                        let reqRet = self.isRequestSuccessWithJsonDict(jsonDict: jsonDict)
                        complete(reqRet,jsonDict)
                        
                    }else{
                        
                        complete(false,kParseError)
                        
                    }
                    
                case .failure(let error):
                    complete(false,error)
            }
            
        }
        
        
    }
    
    //delete请求
    func deleteRequestWithUrl(_ url:String,paramsDict:[String:AnyObject]?,complete:@escaping NetManagerCallback){
        if(self.currentNetWorkStatus == .notReachable){
            complete(false,kNetWorkFailTips);
            return;
        }
        
        Alamofire.request(url, method: .delete, parameters: paramsDict).responseJSON { [unowned self](response) in
            
            switch response.result {
            case .success:
                var jsonDict:Dictionary<String, Any> = Dictionary()
                
                if self.canParseResponseObject(responseObject: response.data, jsonDict: &jsonDict){
                    
                    complete(true,jsonDict)
                    
                }else{
                    
                    complete(false,kParseError)
                    
                }
                
            case .failure(let error):
                complete(false,error)
            }
            
        }

    }
    
    //put请求
    func putRequestWithUrl(_ url:String,paramsDict:[String:AnyObject]?,complete:@escaping NetManagerCallback) {
        if(self.currentNetWorkStatus == .notReachable){
            complete(false,kNetWorkFailTips);
            return;
        }
        
        Alamofire.request(url, method: .put, parameters: paramsDict).responseJSON { [unowned self](response) in
            
            switch response.result {
            case .success:
                var jsonDict:Dictionary<String, Any> = Dictionary()
                
                if self.canParseResponseObject(responseObject: response.data, jsonDict: &jsonDict){
                    
                    complete(true,jsonDict)
                    
                }else{
                    
                    complete(false,kParseError)
                    
                }
                
            case .failure(let error):
                complete(false,error)
            }
            
        }
        
    }
    
    //上传请求
    func uploadRequestWithUrl(url:String,paramsDict:[String:AnyObject]?,imageArray:[UIImage],fileNames:[String],name:String,mimeType:String,progress:@escaping YHUploadProgress,complete:@escaping NetManagerCallback){
        
        if(self.currentNetWorkStatus == .notReachable){
            complete(false,kNetWorkFailTips);
            progress(0,0);
            return;
        }
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
               
                //1.上传单张或多张图片
                for i in 0..<imageArray.count{
                    let image = imageArray[i];
                    
                    var imageData: Data?
                    autoreleasepool {
                        imageData = UIImageJPEGRepresentation(image, 0.5)
                    }
                    
                    //2.上传的参数名
                    let formatter:DateFormatter = DateFormatter();
                    formatter.dateFormat = "yyyyMMddHHmmss";
                    let strDate:String = formatter.string(from: Date())
                    
                    //3.取出单个图片名字
                    var fileName = ""
                    if i < fileNames.count {
                        fileName = fileNames[i]
                    }
                    
                    //保存在服务器的文件名
                    var fileNameInServer = ""
                    if fileName.isEmpty {
                        
                        fileNameInServer = "\(strDate).jpg"
                    }else{
                        var strExt = "" //扩展名
                        var strName = ""
                        let arrName = fileName.components(separatedBy: ".")
                        if arrName.count > 1 {
                            strExt = arrName.last!
                        }
                        let length = fileName.characters.count - strExt.characters.count
                        if length > 0 {
                            let index = fileName.index(fileName.startIndex, offsetBy: length)
                            strName = fileName.substring(to: index)
                        }
                        
                        if strExt.characters.count == 0 {
                            strExt = "png" // 默认图片后续为.png
                        }
                        
                        fileNameInServer = "\(strDate)\(strName).\(strExt)"
                        
                    }
                    
                    
                    //3.上传图片，以文件流的格式
                    if imageData != nil {
                        multipartFormData.append(imageData!, withName: name, fileName:fileNameInServer, mimeType: mimeType)
                    }
                    
                    //4.拼接其他参数 (待完善。。。)
                    guard  YHUserInfoManager.shareInstanced.userInfo?.accessToken != nil else{
                        complete(false,kError_TokenIsNil)
                        return
                    }
                    let token:String = (YHUserInfoManager.shareInstanced.userInfo?.accessToken)!
                    multipartFormData.append(token.data(using: String.Encoding.utf8)!, withName: "accessToken")
             

                }
                
  
            },
            to: url,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case let .success(upload, _, _):
                    
                    progress(upload.progress.completedUnitCount,upload.progress.totalUnitCount)
                    upload.responseJSON { response in
                        debugPrint(response)
                       
                        switch response.result {
                        case .success:
                            var jsonDict:Dictionary<String, Any> = Dictionary()
                            
                            if self.canParseResponseObject(responseObject: response.data, jsonDict: &jsonDict){
                                
                                if self.isRequestSuccessWithJsonDict(jsonDict: jsonDict){
                                    complete(true,jsonDict)
                                }else{
                                    let msg = jsonDict["msg"]
                                    if msg is String {
                                        let str = msg as? String
                                        if let ret = str {
                                            complete(false,ret)
                                        }else{
                                            complete(false,"")
                                        }
                                        
                                    }else{
                                        complete(false,"")
                                    }

                                }
  
                            }else{
                                
                                complete(false,kParseError)
                                
                            }
                            
                        case .failure(let error):
                            complete(false,error)
                        }

                        
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    complete(false,encodingError);
                }
            }
        )
        
        
        
    }
    
    // MARK: - Public 数据处理
    //是否可以解析服务器返回的数据
    @inline(__always) func canParseResponseObject(responseObject:Data?,jsonDict:inout Dictionary<String, Any>) -> Bool {
        if  let resposeObj =  responseObject{

            //把Data对象转换回JSON对象
            let jsonGet = try? JSONSerialization.jsonObject(with: resposeObj,
                                                            options:.mutableContainers) as! [String: Any]
            print("Json Object:", jsonGet ?? "json is nil")
            
            if jsonGet != nil {
                jsonDict = jsonGet!
            }
            
            return true

            
        }else{
            return false
        }
        
        
        
        
    }
    
    /**该协议请求是否成功
     *  @param  jsonDict 字典类型的json对象
     *  @return YES:成功 NO:失败
     */
    @inline(__always) func isRequestSuccessWithJsonDict(jsonDict:Dictionary<String, Any>) -> Bool {
        let statusCode = jsonDict["code"] as? String
        if let code = statusCode {
            if code == kSuccessCode {
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    
    // MARK: - filePrivate

    
}


