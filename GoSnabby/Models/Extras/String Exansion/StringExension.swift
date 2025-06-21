//
//  StringExension.swift
//  FFC
//
//  Created by apple on 10/25/18.
//  Copyright © 2018 E com Planner. All rights reserved.
//

import Foundation


extension String {
    
    func dateString(inputformat: String ,outputformat: String) -> String {
        
        
        if self.count == 0 {         
            return ""
        }
        let dateFormatter = DateFormatter()
        let dateFormatter2 = DateFormatter()
        
        dateFormatter.dateFormat = inputformat
        
        //        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: inputformat, options: 0, locale: NSLocale.current)
        
        
        let dateMain = dateFormatter.date(from: self)
        
        dateFormatter2.dateFormat = outputformat
        
//                dateFormatter2.dateFormat = DateFormatter.dateFormat(fromTemplate: outputformat, options: 0, locale: NSLocale.current)
        
        if dateMain != nil {
            return dateFormatter2.string(from: dateMain!)
        }
        
        return "Off"
        
    }
    
    
    func returnDateString(inputformat: String ) -> Date {

        if self.count == 0 {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputformat
        
        
        let dateMain = dateFormatter.date(from: self)
        
        
        return dateMain!
        
    }
    
    func returnDateFromString() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)!
    }

    
    func addDecimalPoints()-> String{
        return String(format: "%.0f", Double(self)!)
    }
    
    func ratingDecimalPoints()-> String{
        return String(format: "%.1f", Double(self)!)
    }
    
    func convertFormatedDate( requiredFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = requiredFormate
        print(requiredFormate, self, dateFormatter.date(from: self))
        return "\(String(describing: dateFormatter.date(from: self)))"
        
    }
    
}


extension Date {
    func dateString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format        
        return dateFormatter.string(from: self)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
