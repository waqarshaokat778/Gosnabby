//
//  SignInModelForAdmin.swift
//  GoSnabby
//
//  Created by Abdullah on 3/3/21.
//

import Foundation
class SigninModelForAdmin: ResponseModel , NSCoding {
    
    var id = ""
    var name = ""
    var address = ""
    var city = ""
    var contact = ""
    var status = ""
    var email = ""
    var logo = ""
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        
        if  json != nil {
            self.id = self.ReturnValue(value: json!["id"] as Any)
            self.name = self.ReturnValue(value: json!["name"] as Any)
            self.address = self.ReturnValue(value: json!["address"] as Any)
            self.city = self.ReturnValue(value: json!["city"] as Any)
            self.contact = self.ReturnValue(value: json!["contact"] as Any)
            self.status = self.ReturnValue(value: json!["status"] as Any)
            self.email = self.ReturnValue(value: json!["email"] as Any)
            self.logo = self.ReturnValue(value: json!["logo"] as Any)
            
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.contact, forKey: "contact")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.logo, forKey: "logo")
       
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self.id = aDecoder.decodeObject(forKey:"id") as? String ?? kEmptyString
        self.name = aDecoder.decodeObject(forKey:"name") as? String ?? kEmptyString
        self.address = aDecoder.decodeObject(forKey:"address") as? String ?? kEmptyString
        self.city = aDecoder.decodeObject(forKey:"city") as? String ?? kEmptyString
        self.contact = aDecoder.decodeObject(forKey:"contact") as? String ?? kEmptyString
        self.status = aDecoder.decodeObject(forKey:"status") as? String ?? kEmptyString
        self.email = aDecoder.decodeObject(forKey:"email") as? String ?? kEmptyString
        self.logo = aDecoder.decodeObject(forKey:"logo") as? String ?? kEmptyString
        
    }
}
