//
//  DepartmentModel.swift
//  GoSnabby
//
//  Created by Abdullah on 3/1/21.
//

import Foundation


//struct DepartmentModel: Codable {
//    let status: Int?
//    let message: String?
//    let data: [DepartmentDataModel]?
//}
//
//struct DepartmentDataModel: Codable {
//    let id: Int?
//    let dep_name: String?
//    let school_id: Int?
//    let created_at, updated_at: String?
//
////    enum CodingKeys: String, CodingKey {
////        case id
////        case depName = "dep_name"
////        case schoolID = "school_id"
////        case created_at = "created_at"
////        case updatedAt = "updated_at"
////    }
//}

class DepartmentModel : ResponseModel {
   
    var id = ""
    var depName = ""
    var schoolId = ""
    var createdAt = ""
    var updatedAt = ""

    init(fromDictionary dictionary: [String:Any]){
           super.init()

        self.id = self.ReturnValue(value: dictionary["id"] as Any)
        self.depName = self.ReturnValue(value: dictionary["dep_name"] as Any)
        self.schoolId = self.ReturnValue(value: dictionary["school_id"] as Any)
        self.createdAt = self.ReturnValue(value: dictionary["created_at"] as Any)
        self.updatedAt = self.ReturnValue(value: dictionary["updated_at"] as Any)
        
    }
}

class EventModel : ResponseModel {
    
    var status = ""
    var image = ""
    var school_id = ""
    var title = ""
    var date_udpated = ""
    var date_created = ""
    var created_by = ""
    var assigned_to = ""

    init(fromDictionary dictionary: [String:Any]){
           super.init()
     
        self.status = self.ReturnValue(value: dictionary["status"] as Any)
        self.image = self.ReturnValue(value: dictionary["image"] as Any)
        self.school_id = self.ReturnValue(value: dictionary["school_id"] as Any)
        self.title = self.ReturnValue(value: dictionary["title"] as Any)
        self.date_udpated = self.ReturnValue(value: dictionary["date_udpated"] as Any)
        self.date_created = self.ReturnValue(value: dictionary["date_created"] as Any)
        self.created_by = self.ReturnValue(value: dictionary["created_by"] as Any)
        self.assigned_to = self.ReturnValue(value: dictionary["assigned_to"] as Any)
        
    }
}
