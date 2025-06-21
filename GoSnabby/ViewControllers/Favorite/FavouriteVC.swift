//
//  FavouriteVC.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 18/02/2021.
//

import Foundation
import UIKit


class FavouriteVC : BaseVC
{
    var objFood : FoodModel!
    @IBOutlet weak var foodsTableView: UITableView!
    @IBOutlet weak var emptyFavIndicator: UIImageView! {
        didSet {
            emptyFavIndicator.isHidden = true
        }
    }
    
    var arrayFood = [FoodModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodsTableView.delegate = self
        self.foodsTableView.dataSource = self
        self.foodsTableView.register(UINib.init(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "FoodCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.TabbarHide(status: false)
        self.navigationClear()
        self.NavigationHide(status: true)
        getLikedFoodList()
    }
    
    func getLikedFoodList() {

        print("Calling getLikedFoodList...")
        self.showLoading()
        arrayFood.removeAll()
//        arrayFood = [FoodModel]()
        var newPAram = [String : AnyObject]()
        newPAram["user_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.id as AnyObject
        newPAram["school_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        NetworkManager.GetAPI(jsonParam: newPAram, WebServiceName: APIName.get_like_product_list) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    if let arrayDummy = dataMain["data"] as? [[String : Any]] {
                        for objMain in arrayDummy {
                            self.arrayFood.append(FoodModel.init(fromDictionary:objMain))
                        }
                        self.foodsTableView.reloadData()

                    }else{
//                        if let dataMessage = dataMain["message"] as? String {
//                            self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
//                        }
                        
                    }
                    
                    self.hideLoading()
                    self.foodsTableView.reloadData()
                    
                }else {
//                    if let dataMessage = dataMain["message"] as? String {
//                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
//                    }
                    self.foodsTableView.reloadData()
                }
            }
        }
        
        
    }
    
}

extension FavouriteVC :  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayFood.count == 0{
            emptyFavIndicator.isHidden = false
        }else {
            emptyFavIndicator.isHidden = true
        }
        return self.arrayFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let foodCell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
    
        foodCell.lblName.text = self.arrayFood[indexPath.row].name
        foodCell.lblDetails.text = self.arrayFood[indexPath.row].detail
        foodCell.lblPrice.text = "$" + self.arrayFood[indexPath.row].price
        if self.arrayFood[indexPath.row].image == "" {
            foodCell.imageViewFood.image = UIImage(named: "imagePlaceholder")
        } else {
            self.downloadImage(imgview: foodCell.imageViewFood, URL: kBaseItemImageURL + self.arrayFood[indexPath.row].image)
        }
    
       foodCell.buttonAddtoCart.tag = indexPath.row
        foodCell.buttonAddtoCart.addTarget(self, action: #selector(self.addToCartAction), for: .touchUpInside)

        foodCell.selectionStyle = .none
        
        //For shadow
//        foodCell.viewForBackground.dropShadow(color: .lightGray, opacity: 0.3, offSet: CGSize(width: -1, height: 2), radius: 3, scale: true)
        foodCell.viewForBackground.borderWidth = 0.4
        foodCell.viewForBackground.borderColor = .lightGray
        foodCell.viewForBackground.cornerRadius = 8
        return foodCell
    }
    
    @objc func addToCartAction(sender : UIButton) {
        
        var itemList: [FoodModel]? = DataManager.sharedInstance.getItems()
        let result = self.arrayFood[sender.tag]
        self.arrayFood[sender.tag].quantity = "1"
        if itemList != nil {
            if let item = itemList?.enumerated().first(where: {$0.element.id == result.id}) {
                let addedQan = Int((itemList?[item.offset].quantity)!)
                itemList?[item.offset].quantity = String( (addedQan ?? 1) + 1)
                print("quantity added", itemList?[item.offset].quantity)
                DataManager.sharedInstance.cartItemsList = itemList
            } else {
                itemList?.append(self.arrayFood[sender.tag])
                DataManager.sharedInstance.cartItemsList = itemList
            }
            
        } else {
            
            DataManager.sharedInstance.cartItemsList = [self.arrayFood[sender.tag]]
        }
        
        DataManager.sharedInstance.saveItems()
//        ShowSuccessAlert(message: self.arrayFood[sender.tag].name + " added in Cart!")
        
        NotificationCenter.default.post(name: updateCartNoti , object: self, userInfo: nil)
        let vc = self.GetView(nameViewController: "ItemAddedInCartAlertVC", nameStoryBoard: "BottomTabbar" ) as! ItemAddedInCartAlertVC
        vc.textToShow = self.arrayFood[sender.tag].name + " Added to cart."
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let foodItemDetailsVC = self.GetView(nameViewController: "FoodItemDetailsVC", nameStoryBoard:kConstantsStoryBoard.FoodItemDetails ) as! FoodItemDetailsVC
        foodItemDetailsVC.objfoodItemDetailsVC = self.arrayFood[indexPath.row]
        self.navigationController?.pushViewController(foodItemDetailsVC, animated: true)
        // SigninVC.schoolIdfromprev = self.arraySchool[indexPath.row].id
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
}
