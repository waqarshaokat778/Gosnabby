//
//  SigninModel.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 09/02/2021.
//

import Foundation
import UIKit


class SigninModel: ResponseModel , NSCoding {
    
    
    var school_id = ""
    var phone = ""
    var created_at = ""
    var email = ""
    var id = ""
    var profile_image = ""
    var user_name = ""
    var password = ""
    var updated_at = ""
    var stripe_customer_id = ""
    var organization_admin = ""
    var is_concession_person = ""
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        if  json != nil {
            self.school_id = self.ReturnValue(value: json!["school_id"] as Any)
            self.phone = self.ReturnValue(value: json!["phone"] as Any)
            self.created_at = self.ReturnValue(value: json!["created_at"] as Any)
            self.email = self.ReturnValue(value: json!["email"] as Any)
            self.id = self.ReturnValue(value: json!["id"] as Any)
            self.profile_image = self.ReturnValue(value: json!["profile_image"] as Any)
            self.user_name = self.ReturnValue(value: json!["user_name"] as Any)
            self.password = self.ReturnValue(value: json!["password"] as Any)
            self.updated_at = self.ReturnValue(value: json!["updated_at"] as Any)
            self.stripe_customer_id = self.ReturnValue(value: json!["stripe_customer_id"] as Any)
            self.organization_admin = self.ReturnValue(value: json!["organization_admin"] as Any)
            self.is_concession_person = self.ReturnValue(value: json!["is_concession_person"] as Any)
        
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.school_id, forKey: "school_id")
        aCoder.encode(self.phone, forKey: "phone")
        aCoder.encode(self.created_at, forKey: "created_at")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.profile_image, forKey: "profile_image")
        aCoder.encode(self.user_name, forKey: "user_name")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.updated_at, forKey: "updated_at")
        aCoder.encode(self.stripe_customer_id, forKey: "stripe_customer_id")
        aCoder.encode(self.stripe_customer_id, forKey: "organization_admin")
        aCoder.encode(self.stripe_customer_id, forKey: "is_concession_person")
       
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String ?? kEmptyString
        self.email = aDecoder.decodeObject(forKey:"email") as? String ?? kEmptyString
        self.id = aDecoder.decodeObject(forKey:"id") as? String ?? kEmptyString
        self.school_id = aDecoder.decodeObject(forKey:"school_id") as? String ?? kEmptyString
        self.phone = aDecoder.decodeObject(forKey:"phone") as? String ?? kEmptyString
        self.profile_image = aDecoder.decodeObject(forKey:"profile_image") as? String ?? kEmptyString
        self.password = aDecoder.decodeObject(forKey:"password") as? String ?? kEmptyString
        self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String ?? kEmptyString
        self.user_name = aDecoder.decodeObject(forKey:"user_name") as? String ?? kEmptyString
        self.stripe_customer_id = aDecoder.decodeObject(forKey:"stripe_customer_id") as? String ?? kEmptyString
        self.organization_admin = aDecoder.decodeObject(forKey:"organization_admin") as? String ?? kEmptyString
        self.is_concession_person = aDecoder.decodeObject(forKey:"is_concession_person") as? String ?? kEmptyString
      
    }
}



//class ResponseModel: NSObject {
//
//    func ReturnValue(value : Any) -> String{
//        if let MainValue = value as? Int {
//            return String(MainValue)
//        }else  if let MainValue = value as? String {
//            return MainValue
//        }else  if let MainValue = value as? Double {
//            return String(MainValue)
//        }
//        return ""
//    }
//}
    



