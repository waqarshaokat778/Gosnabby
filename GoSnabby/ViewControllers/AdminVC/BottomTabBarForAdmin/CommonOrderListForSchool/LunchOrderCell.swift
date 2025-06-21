//
//  LunchOrderCell.swift
//  GoSnabby
//
//  Created by Abdullah on 3/3/21.
//

import UIKit

class LunchOrderCell: UITableViewCell {

    @IBOutlet weak var lblorderNo: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblTransID: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblReceivingDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var btnContainer: UIView! {
        didSet {
            btnContainer.borderWidth = 0.3
            btnContainer.borderColor = UIColor.lightGray
        }
    }
    
    @IBOutlet weak var imgbtnIndicator: UIImageView!
    @IBOutlet weak var lblActionTitle: UILabel!
    
    @IBOutlet weak var container: UIView! {
        didSet {
            container.borderWidth = 0.3
            container.borderColor = UIColor.lightGray
            container.cornerRadius = 8
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))

    }
    @IBOutlet weak var statusContainer: UIView!
    
    @IBOutlet weak var transIdLbl: UILabel!
    @IBOutlet weak var paymentTypeLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var receivingDataLbl: UILabel!
    
}
