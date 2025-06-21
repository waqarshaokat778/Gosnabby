//
//  CategoryModel.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 15/02/2021.
//

import Foundation
           
class CategoryModel : ResponseModel {
   
    var id = ""
    var image = ""
    var name = ""
    var school_id = ""


    init(fromDictionary dictionary: [String:Any]){
           super.init()

        self.id = self.ReturnValue(value: dictionary["id"] as Any)
        self.image = self.ReturnValue(value: dictionary["image"] as Any)
        self.name = self.ReturnValue(value: dictionary["name"] as Any)
        self.school_id = self.ReturnValue(value: dictionary["school_id"] as Any)
        
    }
}
