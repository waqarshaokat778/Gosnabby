//
//  ViewExtension.swift
//  True Express
//
//  Created by apple on 11/6/18.
//  Copyright © 2018 E com Planner. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIView {
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
  
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
 
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }

    
}

extension UITextField {
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
}


extension UIView {
    
    func RoundCornerWithColor(colorMain : UIColor = UIColor.lightGray)  {
           self.layer.borderWidth = 1;
           self.layer.cornerRadius = self.frame.size.height/2
           self.layer.borderColor = colorMain.cgColor
           self.clipsToBounds = true
           self.layer.masksToBounds = false
       }
    
    func RoundCornerWithColor(colorMain : UIColor = UIColor.lightGray , cornerRadious : CGFloat = 10.0)  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = cornerRadious
        self.layer.borderColor = colorMain.cgColor
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
    
    func RoundCorner(colorMain : UIColor = kConstantsColors.kNavigationcolor)  {
           self.layer.borderWidth = 5;
           self.layer.cornerRadius = self.frame.size.height/2
           self.layer.borderColor = colorMain.cgColor
           self.clipsToBounds = true
           self.layer.masksToBounds = false
       }
    
}


extension UIImageView {
    func downloadPropertyImage( URL : String){
        
        let newURL = (kBaseSchoolImageURL + URL).replacingOccurrences(of: " ", with: "%20")

        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        if let newURL = NSURL(string:  newURL) as? URL {
            self.sd_setImage(with: newURL, placeholderImage: UIImage(named: "PlaceHolder"))
        }else {
            let newURL2 = (kBaseSchoolImageURL + (URL).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            
            self.sd_setImage(with: NSURL(string:  newURL2) as? URL, placeholderImage: UIImage(named: "PlaceHolder"))
        }
        
    }
}

extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
    
      
}
