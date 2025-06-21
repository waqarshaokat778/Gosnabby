//
//  FoodModel.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 16/02/2021.
//

import Foundation
    
class FoodModel : ResponseModel, NSCoding {
    
    var product_type = ""
    var detail = ""
    var is_like = ""
    var available_items = ""
    var created_at = ""
    var price = ""
    var id = ""
    var image = ""
    var name = ""
    var category_id = ""
    var updated_at = ""
    var school_id = ""
    var descriptionFrom = ""
    var quantity = ""
    
    internal init(product_type: String = "", detail: String = "", is_like: String = "", available_items: String = "", created_at: String = "", price: String = "", id: String = "", image: String = "", name: String = "", category_id: String = "", updated_at: String = "", school_id: String = "", descriptionFrom: String = "", quantity: String = "") {
        self.product_type = product_type
        self.detail = detail
        self.is_like = is_like
        self.available_items = available_items
        self.created_at = created_at
        self.price = price
        self.id = id
        self.image = image
        self.name = name
        self.category_id = category_id
        self.updated_at = updated_at
        self.school_id = school_id
        self.descriptionFrom = descriptionFrom
        self.quantity = quantity
    }
    
    init(fromDictionary dictionary: [String:Any]){
           super.init()
        self.product_type = self.ReturnValue(value: dictionary["product_type"] as Any)
        self.detail = self.ReturnValue(value: dictionary["detail"] as Any)
        self.is_like = self.ReturnValue(value: dictionary["is_like"] as Any)
        self.descriptionFrom = self.ReturnValue(value: dictionary["description"] as Any)
        self.available_items = self.ReturnValue(value: dictionary["available_items"] as Any)
        self.created_at = self.ReturnValue(value: dictionary["created_at"] as Any)
        self.price = self.ReturnValue(value: dictionary["price"] as Any)
        self.id = self.ReturnValue(value: dictionary["id"] as Any)
        self.image = self.ReturnValue(value: dictionary["image"] as Any)
        self.name = self.ReturnValue(value: dictionary["name"] as Any)
        self.category_id = self.ReturnValue(value: dictionary["category_id"] as Any)
        self.updated_at = self.ReturnValue(value: dictionary["updated_at"] as Any)
        self.school_id = self.ReturnValue(value: dictionary["school_id"] as Any)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.product_type, forKey: "product_type")
        aCoder.encode(self.detail, forKey: "detail")
        aCoder.encode(self.is_like, forKey: "is_like")
        aCoder.encode(self.descriptionFrom, forKey: "descriptionFrom")
        aCoder.encode(self.available_items, forKey: "available_items")
        aCoder.encode(self.created_at, forKey: "created_at")
        aCoder.encode(self.price, forKey: "price")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.category_id, forKey: "category_id")
        aCoder.encode(self.updated_at, forKey: "updated_at")
        aCoder.encode(self.school_id, forKey: "school_id")
        aCoder.encode(self.quantity, forKey: "quantity")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self.product_type = aDecoder.decodeObject(forKey:"product_type") as? String ?? kEmptyString
        self.detail = aDecoder.decodeObject(forKey:"detail") as? String ?? kEmptyString
        self.is_like = aDecoder.decodeObject(forKey:"is_like") as? String ?? kEmptyString
        self.descriptionFrom = aDecoder.decodeObject(forKey:"descriptionFrom") as? String ?? kEmptyString
        self.available_items = aDecoder.decodeObject(forKey:"available_items") as? String ?? kEmptyString
        self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String ?? kEmptyString
        self.price = aDecoder.decodeObject(forKey:"price") as? String ?? kEmptyString
        self.id = aDecoder.decodeObject(forKey:"id") as? String ?? kEmptyString
        self.image = aDecoder.decodeObject(forKey:"image") as? String ?? kEmptyString
        self.name = aDecoder.decodeObject(forKey:"name") as? String ?? kEmptyString
        self.category_id = aDecoder.decodeObject(forKey:"category_id") as? String ?? kEmptyString
        self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String ?? kEmptyString
        self.school_id = aDecoder.decodeObject(forKey:"school_id") as? String ?? kEmptyString
        self.quantity = aDecoder.decodeObject(forKey:"quantity") as? String ?? kEmptyString
      
    }
}



