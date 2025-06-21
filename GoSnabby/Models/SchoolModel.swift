//
//  SchoolsList.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 29/01/2021.
//

import Foundation

class SchoolModel : ResponseModel {
    var address = ""
    var city = ""
    var contact = ""
    var created_at = ""
    var email = ""
    var id = ""
    var logo = ""
    var name = ""
    var password = ""
    var password_real = ""
    var status = ""
    var sales_tax = ""
    
    init(fromDictionary dictionary: [String:Any]){
           super.init()

        self.address = self.ReturnValue(value: dictionary["address"] as Any)
        self.city = self.ReturnValue(value: dictionary["city"] as Any)
        self.contact = self.ReturnValue(value: dictionary["contact"] as Any)
        self.created_at = self.ReturnValue(value: dictionary["created_at"] as Any)
        self.email = self.ReturnValue(value: dictionary["email"] as Any)
        self.id = self.ReturnValue(value: dictionary["id"] as Any)
        self.logo = self.ReturnValue(value: dictionary["logo"] as Any)
        self.name = self.ReturnValue(value: dictionary["name"] as Any)
        self.password = self.ReturnValue(value: dictionary["password"] as Any)
        self.password_real = self.ReturnValue(value: dictionary["password_real"] as Any)
        self.status = self.ReturnValue(value: dictionary["status"] as Any)
        self.sales_tax = self.ReturnValue(value: dictionary["sales_tax"] as Any)
    }
}
