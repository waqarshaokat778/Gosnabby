//
//  DataManager.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 11/02/2021.
//

import UIKit

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
//    var arrayFav = [SigninModel]()
    
    var user: SigninModel? {
        didSet {
            saveUserPermanentally()
        }
    }
    var admin:  SigninModelForAdmin? {
        didSet {
            saveAdminPermanentally()
        }
    }
    var cartItemsList: [FoodModel]?

    func logoutUser() {
        
        let newUser = SigninModel.init()
        user = nil
        user = newUser
        self.saveUserPermanentally()
        
        UserDefaults.standard.removeObject(forKey: "cart")
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "admin")
        UserDefaults.standard.removeObject(forKey: "isVisited")
        
    }
    
    func saveUserPermanentally() {
        if user != nil {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: user!)
            UserDefaults.standard.set(encodedData, forKey: "user")
            
        } else {
            UserDefaults.standard.removeObject(forKey: "user")
        }
    }
    
    func getPermanentlySavedUser() -> SigninModel? {
        
        if let data = UserDefaults.standard.data(forKey: "user"),
            let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? SigninModel {
            return userData
        } else {
            return SigninModel.init(json: ["" : "" as AnyObject])
        }
    }
    
    func saveAdminPermanentally() {
//        if admin != nil {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: admin!)
            UserDefaults.standard.set(encodedData, forKey: "admin")
            
//        } else {
//            UserDefaults.standard.removeObject(forKey: "admin")
//        }
    }
    
    func getPermanentlySavedAdmin() -> SigninModelForAdmin? {
        
        if let data = UserDefaults.standard.data(forKey: "admin"),
            let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? SigninModelForAdmin {
            return userData
        } else {
            return SigninModelForAdmin.init(json: ["" : "" as AnyObject])
        }
    }
    
    
    
//    handle cart
    func saveItems() {
//        if cartItemsList != nil {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: cartItemsList!)
            UserDefaults.standard.set(encodedData, forKey: "cart")
            
//        }else {
//            UserDefaults.standard.removeObject(forKey: "cart")
//        }
    }
    
    func getItems() -> [FoodModel]? {
        
        if let data = UserDefaults.standard.data(forKey: "cart"),
            let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [FoodModel] {
            return userData
        } else {
            return nil
        }
    }
}
