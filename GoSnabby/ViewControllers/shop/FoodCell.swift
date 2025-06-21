//
//  FoodCell.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 16/02/2021.
//

import Foundation
import UIKit

class FoodCell : UITableViewCell {
    

    @IBOutlet weak var viewForBackground: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imageViewFood: UIImageView!
   
    @IBOutlet weak var buttonAddtoCart: UIButton!
    
    @IBOutlet weak var addToCartLbl: UILabel!
    
    @IBOutlet weak var cartIcon: UIImageView!
    @IBOutlet weak var quantityLbl: UILabel! {
        didSet {
            quantityLbl.isHidden = true
        }
    }
}
