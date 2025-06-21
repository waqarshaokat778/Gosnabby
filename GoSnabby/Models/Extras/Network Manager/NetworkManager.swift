 //
 //  NetworkManager.swift
 //
 //
 //  Created by Apple on 29/12/2016.
 //  Copyright © 2016 Apple. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 import WebKit
 import GCNetworkReachability
 import CoreLocation
 
 
 class NetworkManager: NSObject {
    
    //
    class func isNetworkReachable() -> Bool {
        let reachablity = GCNetworkReachability(internetAddressString: kServerIPAddress)
        let reachable = reachablity?.isReachable()
        reachablity?.stopMonitoringNetworkReachability()
        return reachable!
    }
    
    private class func sendJSONToServer(jsonParam: [String: AnyObject]?, webserviceName: String, isPostRequest: Int = 1, completion: @escaping (_ success: Bool, _ message: String, _ response: Any) -> Void) -> Request? {
        var json = jsonParam as? [String : Any]
        var headers :  HTTPHeaders?
        
        print(headers as Any)
        print("json ===> ")
        print(json as Any)
        
        if NetworkManager.isNetworkReachable() {
            let postURLString = kBaseURLString + webserviceName
            
            var apiCall : HTTPMethod = .get
            
            if isPostRequest == 1 {
                apiCall = .post
            }else if isPostRequest == 2 {
                apiCall = .delete
            }else if isPostRequest == 3 {
                apiCall = .put
            }
            
            
            AF.request(postURLString, method: apiCall, parameters: json ,headers : headers).responseJSON(completionHandler: { (response) in
                if response.data != nil {
                    completion(true, "", (self.nsdataToJSON(data: response.data!)))
                }else {
                    completion(false, kNetworkNotAvailableMessage, ["message" : kNetworkNotAvailableMessage])
                    
                }
            })
            
        }else {
            completion(false, kNetworkNotAvailableMessage, ["message" : kNetworkNotAvailableMessage])
        }
        return nil
    }
    
    class func nsdataToJSON(data: Data) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    class func GetAPI(jsonParam: [String: AnyObject]?, WebServiceName : String, completion: @escaping (_ success: Bool, _ message: String , _ response: Any) -> Void ) {
        
        _ = NetworkManager.sendJSONToServer(jsonParam: jsonParam, webserviceName: WebServiceName , isPostRequest : 0) { (success, message, response) -> Void in
            
            completion(success, message , response)
        }
    }
    
    class func PostAPI(jsonParam: [String: AnyObject]?, WebServiceName : String, completion: @escaping (_ success: Bool, _ message: String , _ response:Any) -> Void ) {
        print(jsonParam, WebServiceName)
        _ = NetworkManager.sendJSONToServer(jsonParam: jsonParam, webserviceName: WebServiceName , isPostRequest : 1) { (success, message, response) -> Void in
            
            completion(success, message , response)
        }
    }
    
    
    class func fetchDataGetURL(MainURL : String , Completion:@escaping (Swift.Result<Any, Error>)->()) {
        let url = URL(string:MainURL)
        let request = AF.request(url!, method: .get)
        request.responseJSON(completionHandler: { response in
            guard response.error == nil else {
                Completion(.failure(response.error!))
                return
            }
            do {
                switch response.result  {
                case .success(let resp):
                    Completion(.success(resp))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    
    class func DeleteAPI(jsonParam: [String: AnyObject]?, WebServiceName : String, completion: @escaping (_ success: Bool, _ message: String , _ response: Any) -> Void ) {
        
        _ = NetworkManager.sendJSONToServer(jsonParam: jsonParam, webserviceName: WebServiceName , isPostRequest : 2) { (success, message, response) -> Void in
            
            completion(success, message , response)
        }
    }
    
    
    class func PutAPI(jsonParam: [String: AnyObject]?, WebServiceName : String, completion: @escaping (_ success: Bool, _ message: String , _ response: Any) -> Void ) {
        
        _ = NetworkManager.sendJSONToServer(jsonParam: jsonParam, webserviceName: WebServiceName , isPostRequest : 3) { (success, message, response) -> Void in
            
            completion(success, message , response)
        }
    }
    
    
    class func PostUserImageAPI(jsonParam: [String: Any]?, WebServiceName : String, imageMain : UIImage?,_ imageKey: String = "profile_image", completion: @escaping (_ success: Bool, _ message: String , _ response: Any?) -> Void ) {
        
        var headers = [String : String]()
        let url = kBaseURLString + WebServiceName
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key,value) in jsonParam! {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            if imageMain != nil {
                if let imageData = imageMain!.jpegData(compressionQuality: 0.6) {
                    multipartFormData.append(imageData, withName: imageKey, fileName: "a.jpg", mimeType: "image/jpeg")
                }
            }
            
        }, to: url)
        
        .responseString{ response in
            print("response ===>")
            print(response)
            print("response.result ===> ")
            print(response.result)
            print("response.error ===> ")
            print(response.error as Any)
            if response.error == nil {
                completion(true,"", self.nsdataToJSON(data: response.data!))
            }else {
                completion(false, response.error.debugDescription, nil)
            }
        }
    }
    
 }
