//
//  FoodItemDetailsVC.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 17/02/2021.
//

import Foundation
import UIKit


class FoodItemDetailsVC: BaseVC {
    
    var objfoodItemDetailsVC : FoodModel!
    var itemInCard: FoodModel!
    var islike = false
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSubname: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblquantity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemInCard = objfoodItemDetailsVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO change the deprecated code 
        UIApplication.shared.isStatusBarHidden = true
        self.NavigationHide(status: false)
        self.TabbarHide(status: true)
        self.AddBackButton()
        self.UpdateTitle(title: objfoodItemDetailsVC.name, color: UIColor.white)
        
        lblName.text = objfoodItemDetailsVC.name
        lblPrice.text = objfoodItemDetailsVC.price
        lblSubname.text = objfoodItemDetailsVC.detail
        lblDescription.text = objfoodItemDetailsVC.descriptionFrom
        
        self.downloadImage(imgview: imageFood, URL: kBaseItemImageURL + self.objfoodItemDetailsVC.image)
        
        
        if objfoodItemDetailsVC.is_like == "1" {
            self.addRightButtonWithImage(selector: #selector(UnlikeAction), imageMain: UIImage.init(named: "like")!)
        }else{
            self.addRightButtonWithImage(selector: #selector(likeAction), imageMain: UIImage.init(named: "unlike")!)
        }
        
    }
    
    @IBAction func AddOneAction(_ sender: Any) {
        let count  = Int(lblquantity.text!)
        lblquantity.text = String((count ?? 1) + 1)
        if Float(objfoodItemDetailsVC.price) != nil {
            let price = Float(objfoodItemDetailsVC.price)! * Float(count! + 1)
            lblPrice.text = String(format: "%.02f", price)
        }
    }
    
    @IBAction func lessOneAction(_ sender: Any) {
        let count  = Int(lblquantity.text!)
        if count! > 1 {
            lblquantity.text = String((count ?? 1) - 1)
            if Float(objfoodItemDetailsVC.price) != nil {
                let price = Float(objfoodItemDetailsVC.price)! * Float(count! - 1)
                lblPrice.text = String(format: "%.02f", price)
            }
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        itemInCard.quantity = lblquantity.text!
        var itemList: [FoodModel]? = DataManager.sharedInstance.getItems()
        if itemList != nil {
            
            if let item = itemList?.enumerated().first(where: {$0.element.id == itemInCard.id}) {
                let addedQan = Int((itemList?[item.offset].quantity)!)
                itemList?[item.offset].quantity = String( (addedQan ?? 1) + Int(lblquantity.text!)!)
                print("quantity added", itemList?[item.offset].quantity)
                DataManager.sharedInstance.cartItemsList = itemList
            } else {
                itemList?.append(itemInCard)
                DataManager.sharedInstance.cartItemsList = itemList
            }
            
        } else {
            DataManager.sharedInstance.cartItemsList = [itemInCard]
        }
        DataManager.sharedInstance.saveItems()
        
        NotificationCenter.default.post(name: updateCartNoti , object: self, userInfo: nil)

//        self.navigationController?.popViewController(animated: true)
        
        let vc = self.GetView(nameViewController: "ItemAddedInCartAlertVC", nameStoryBoard: "BottomTabbar" ) as! ItemAddedInCartAlertVC
        vc.textToShow = objfoodItemDetailsVC.name + " Added to cart."
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
//        self.ShowSuccessAlert(message: )

    }
    
    @objc func likeAction(sender : UIButton){
        islike = true
        likeUnlikeAction()
    }
    
    @objc func UnlikeAction(sender : UIButton){
        islike = false
        likeUnlikeAction()
    }
    
    func likeUnlikeAction() {
        
        self.showLoading()
        var param = [String : AnyObject]()
        param["user_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.id as AnyObject
        param["product_id"] = self.objfoodItemDetailsVC.id as AnyObject
        param["school_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        
        print("Params-->> 777")
        print(DataManager.sharedInstance.getPermanentlySavedUser()?.id as Any)
        print(objfoodItemDetailsVC.id)
        print(DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as Any)
        print("End")

        
        NetworkManager.PostAPI(jsonParam: param, WebServiceName: APIName.like_dislike) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    self.hideLoading()

                    if let dataMessage = dataMain["message"] as? String {
                        if self.islike {
                            self.addRightButtonWithImage(selector: #selector(self.UnlikeAction), imageMain: UIImage.init(named: "like")!)
                        }else{
                            self.addRightButtonWithImage(selector: #selector(self.likeAction), imageMain: UIImage.init(named: "unlike")!)
                        }
                        print(dataMessage)
                    }else{
                        self.ShowErrorAlert(message: "Something wrong" , AlertTitle: "")
                        
                    }
                    
                }else {
                    self.hideLoading()
                    if let dataMessage = dataMain["message"] as? String {
                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
                    }else{
                        self.ShowErrorAlert(message: "Something wrong" , AlertTitle: "")
                        
                    }
                }
                
                
            }
            
        }
        
    }
    
}


