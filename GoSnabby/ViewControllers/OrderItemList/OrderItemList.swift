//
//  OrderItemList.swift
//  GoSnabby
//
//  Created by Abdullah on 5/28/21.
//

import UIKit

class OrderItemList: BaseVC {
    
    var orderDataList: [OrderProductsList]?
        
    @IBOutlet weak var orderHistoryTbl: UITableView!
    @IBOutlet weak var emptyIndicator: UIImageView! {
        didSet {
            emptyIndicator.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderHistoryTbl.register(UINib.init(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "FoodCell")
        self.orderHistoryTbl.delegate = self
        self.orderHistoryTbl.dataSource = self
    }
    
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension OrderItemList: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.setupEmptyIndicator(isShow: orderDataList?.count == 0 || orderDataList?.count == nil)
            return orderDataList?.count ?? 0
        
    }
    
    func setupEmptyIndicator(isShow: Bool) {
        if isShow {
            emptyIndicator.isHidden = false
        } else {
            emptyIndicator.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return returnItemListCell(indexPath: indexPath)
    }

    func returnItemListCell(indexPath: IndexPath) -> FoodCell {
        
        let foodCell = orderHistoryTbl.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        let result = orderDataList?[indexPath.row]
        
        foodCell.lblName.text = result?.name
        foodCell.lblDetails.text = result?.detail
        foodCell.lblPrice.text = "$" + String((result?.price)!)
        foodCell.quantityLbl.text = "Quantity " + (result?.quantity)!
        if result?.image == "" ||  result?.image == nil  {
            foodCell.imageViewFood.image = UIImage(named: "imagePlaceholder")
        } else {
            self.downloadImage(imgview: foodCell.imageViewFood, URL: kBaseItemImageURL + (result?.image)!)
        }
        
        foodCell.buttonAddtoCart.isHidden = true
        foodCell.cartIcon.isHidden = true
        foodCell.addToCartLbl.isHidden = true
        foodCell.quantityLbl.isHidden = false
        
        foodCell.selectionStyle = .none
        
        //For shadow
//        foodCell.viewForBackground.dropShadow(color: .lightGray, opacity: 0.3, offSet: CGSize(width: -1, height: 2), radius: 3, scale: true)
        foodCell.viewForBackground.borderWidth = 0.4
        foodCell.viewForBackground.borderColor = .lightGray
        foodCell.viewForBackground.cornerRadius = 6
        
        return foodCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
}

