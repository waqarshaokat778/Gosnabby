//
//  OrderHistoryCell.swift
//  GoSnabby
//
//  Created by Abdullah on 5/28/21.
//

import UIKit

class OrderHistoryCell:  UITableViewCell {
    
    @IBOutlet weak var viewForBackground: UIView!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var lblOrderDate: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var devlivedView: UIView!
    
}
