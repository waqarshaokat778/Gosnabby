//
//  CartCell.swift
//  GoSnabby
//
//  Created by Abdullah on 2/21/21.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView! {
        didSet {
            container.layer.cornerRadius = 4
            container.layer.shadowColor = #colorLiteral(red: 0.7574564815, green: 0.7574744821, blue: 0.7574648261, alpha: 0.621281036)
            container.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            container.layer.shadowRadius = 2.0
            container.layer.shadowOpacity = 0.65
        }
    }
    @IBOutlet weak var removeItem: UIButton!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var addItem: UIButton!
    @IBOutlet weak var minItem: UIButton!
    @IBOutlet weak var itemCount: UITextField!
    @IBOutlet weak var itemImage: UIImageView!

}
