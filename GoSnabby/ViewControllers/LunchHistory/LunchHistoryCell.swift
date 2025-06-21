//
//  LunchHistoryCell.swift
//  GoSnabby
//
//  Created by Abdullah on 2/25/21.
//

import UIKit

class LunchHistoryCell: UITableViewCell {

    @IBOutlet weak var viewForBackground: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblCompleteDate: UILabel!
    
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusBgColorImg: UIImageView!
}
