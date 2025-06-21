//
//  ShopVC.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 12/02/2021.
//

import Foundation
import UIKit


class ShopVC : BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate
{
    var SearchBarValue:String!
    var searchActive : Bool = false
    var objFood : FoodModel!
    var selectedCategoryId: String = "-1"
//    var selectedCategoryIndex = -1
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var foodsTableView: UITableView!
    @IBOutlet weak var emptyIndicator: UIImageView! {
        didSet {
            emptyIndicator.isHidden = true
        }
    }
    @IBOutlet weak var allItemLbl: UILabel!
    
    
    var arrayCategory = [CategoryModel]()
    var arrayFood = [FoodModel]()
    var filtered = [FoodModel]()
    
    var isSearchEnable = false
    var searchResult = [FoodModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.showsCancelButton = false
        self.foodsTableView.delegate = self
        self.foodsTableView.dataSource = self
        self.searchBar.delegate = self
        
        filtered = [FoodModel]()
        
        self.categoryCollectionView.register(UINib.init(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        
        self.foodsTableView.register(UINib.init(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "FoodCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationClear()
        self.NavigationHide(status: true)
        self.TabbarHide(status: false)
        
//        if DataManager.sharedInstance.user?.phone == "" {
            let isVisited =  UserDefaults.standard.bool(forKey: "isVisited")
             if  isVisited != true {
                openAlertForPhoneNo()
             }
            
//        }
        
        getCategoryList()
        getFoodList()
        changeSearchBarPlaceholderColur()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .black
    }
    
    func openAlertForPhoneNo() {
        if DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes" || DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes"  {
            let alertForInfoVC = self.GetView(nameViewController: "AlertForInfoVC", nameStoryBoard: "BottomTabbar" ) as! AlertForInfoVC
//            if DataManager.sharedInstance.user?.phone != "" {
////                alertForInfoVC.hidePhone = true
//            }
            alertForInfoVC.hideName = false
            alertForInfoVC.modalPresentationStyle = .overCurrentContext
            self.present(alertForInfoVC, animated: true)
            
        } else {
            if DataManager.sharedInstance.user?.phone == "" {
                let alertForInfoVC = self.GetView(nameViewController: "AlertForInfoVC", nameStoryBoard: "BottomTabbar" ) as! AlertForInfoVC
//                if DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes" || DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes"  {
//                    alertForInfoVC.hideName = false
//                }
                alertForInfoVC.modalPresentationStyle = .overCurrentContext
                self.present(alertForInfoVC, animated: true)
            }
            
        }
        
        
    }
    
    func changeSearchBarPlaceholderColur(){
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Food", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            searchBar.searchTextField.leftView?.tintColor = .black
            searchBar.tintColor = UIColor.black
        } else {
            let searchField = searchBar.value(forKey: "searchField") as! UITextField
            searchField.attributedPlaceholder = NSAttributedString(string: "Search Food", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            searchBar.searchTextField.leftView?.tintColor = .black
            searchBar.tintColor = UIColor.black
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.text = nil
        searchBar.resignFirstResponder()
        foodsTableView.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        foodsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func getCategoryList() {
        print("Calling getCategoryList...")
        self.showLoading()
        arrayCategory.removeAll()
        arrayCategory = [CategoryModel]()
        var newPAram = [String : AnyObject]()
        newPAram["school_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        NetworkManager.GetAPI(jsonParam: newPAram, WebServiceName: APIName.getcategories) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    if let arrayDummy = dataMain["data"] as? [[String : Any]] {
                        for objMain in arrayDummy {
                            self.arrayCategory.append(CategoryModel.init(fromDictionary:objMain))
                        }
                        print("arrayCategory.count ===> " )
                        print(self.arrayCategory.count)
                        self.categoryCollectionView.reloadData()
                    }else{
                        //Remove the alert
//                        if let dataMessage = dataMain["message"] as? String {
//                            self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
//                        }
                        
                    }
                    
                    self.hideLoading()
                  //hide this on sir Umer Requirment
//                }else {
//                    if let dataMessage = dataMain["message"] as? String {
//                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
//                    }
                }
            }
        }
        
        
    }
    
    func getFoodList() {
        print("Calling getFoodList...")
        self.showLoading()
        arrayFood.removeAll()
        arrayFood = [FoodModel]()
        var newPAram = [String : AnyObject]()
        newPAram["user_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.id as AnyObject
        newPAram["school_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        NetworkManager.GetAPI(jsonParam: newPAram, WebServiceName: APIName.get_all_like_unlike_product_list) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    if let arrayDummy = dataMain["data"] as? [[String : Any]] {
                        for objMain in arrayDummy {
                            self.arrayFood.append(FoodModel.init(fromDictionary:objMain))
                        }
                        print("arrayFood.count ===> " )
                        print(self.arrayFood.count)
                        
                        self.filtered = self.arrayFood
                        self.foodsTableView.reloadData()
                        
                    }else{
                        //Not showing the alert
//                        if let dataMessage = dataMain["message"] as? String {
//                            self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
//                        }
                        
                    }
                    
                    self.hideLoading()
                    //hide this on sir Umer Requirment
//                }else {
//                    if let dataMessage = dataMain["message"] as? String {
//                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
//                    }
                }
            }
        }
        
        
    }
    
}

extension ShopVC {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayCategory.count == 0 {
            allItemLbl.isHidden = true
            return 0
        }
        allItemLbl.isHidden = false
        return arrayCategory.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellMain = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        if indexPath.row == 0 {
            cellMain.lblName.text = "ALL ITEMS"
            cellMain.imageviewDisplay.image = UIImage(named: "CollectionFood")
        } else {
            let index = indexPath.row - 1
            cellMain.lblName.text = self.arrayCategory[index].name
            
            if self.arrayCategory[index].image == "" {
                cellMain.imageviewDisplay.image = UIImage(named: "imagePlaceholder")
            } else {
                self.downloadImage(imgview: cellMain.imageviewDisplay, URL: kBaseItemImageURL + self.arrayCategory[index].image)
            }
        }
        return cellMain
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 20) / 3
        let height = collectionView.frame.size.height - 10
        return CGSize(width: width, height:height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.filtered = self.arrayFood
            self.foodsTableView.reloadData()
        } else {
            let index = indexPath.row - 1
            selectedCategoryId = arrayCategory[index].id
//            selectedCategoryIndex = indexPath.row
            let filter = self.arrayFood.filter { (item) -> Bool in
                return item.category_id == arrayCategory[index].id
            }
            self.filtered = filter
            self.foodsTableView.reloadData()
            self.categoryCollectionView.reloadData()
        }
    }
}

extension ShopVC :  UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchEnable {
            setupEmptyIndicator(isShow: self.searchResult.count == 0)
            return searchResult.count
        }
        setupEmptyIndicator(isShow: self.filtered.count == 0)
        return self.filtered.count
    }
    
    func setupEmptyIndicator(isShow: Bool) {
        if isShow {
            emptyIndicator.isHidden = false
        } else {
            emptyIndicator.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let foodCell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        var result = self.filtered[indexPath.row]
        if isSearchEnable {
            result = self.searchResult[indexPath.row]
        }
        
        foodCell.lblName.text = result.name
        foodCell.lblDetails.text = result.detail
        foodCell.lblPrice.text = "$" + result.price
        if result.image == "" {
            foodCell.imageViewFood.image = UIImage(named: "imagePlaceholder")
        } else {
            self.downloadImage(imgview: foodCell.imageViewFood, URL: kBaseItemImageURL + result.image)
        }
        
        
        foodCell.buttonAddtoCart.tag = indexPath.row
//        objFood = result
        foodCell.buttonAddtoCart.addTarget(self, action: #selector(self.addToCartAction), for: .touchUpInside)
        
        foodCell.selectionStyle = .none
        
        //For shadow
//        foodCell.viewForBackground.dropShadow(color: .lightGray, opacity: 0.3, offSet: CGSize(width: -1, height: 2), radius: 3, scale: true)
        foodCell.viewForBackground.borderWidth = 0.4
        foodCell.viewForBackground.borderColor = .lightGray
        foodCell.viewForBackground.cornerRadius = 8
        
        return foodCell
    }
    
    @objc func addToCartAction(sender : UIButton){
        var itemList: [FoodModel]? = DataManager.sharedInstance.getItems()
        var result = self.filtered[sender.tag]
        if isSearchEnable {
            result = self.searchResult[sender.tag]
        }
        result.quantity = "1"
        
        if itemList != nil {
//            result.id
            
            if let item = itemList?.enumerated().first(where: {$0.element.id == result.id}) {
                let addedQan = Int((itemList?[item.offset].quantity)!)
                itemList?[item.offset].quantity = String( (addedQan ?? 1) + 1)
                print("quantity added", itemList?[item.offset].quantity)
                DataManager.sharedInstance.cartItemsList = itemList
            } else {
                itemList?.append(result)
                DataManager.sharedInstance.cartItemsList = itemList
            }
            
        } else {
            DataManager.sharedInstance.cartItemsList = [result]
        }
        
        DataManager.sharedInstance.saveItems()
//        ShowSuccessAlert(message: result.name + " added in Cart!")
        
        NotificationCenter.default.post(name: updateCartNoti , object: self, userInfo: nil)
        let vc = self.GetView(nameViewController: "ItemAddedInCartAlertVC", nameStoryBoard: "BottomTabbar" ) as! ItemAddedInCartAlertVC
        vc.textToShow = result.name + " Added to cart."
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let foodItemDetailsVC = self.GetView(nameViewController: "FoodItemDetailsVC", nameStoryBoard:kConstantsStoryBoard.FoodItemDetails ) as! FoodItemDetailsVC
        var result = self.filtered[indexPath.row]
        if isSearchEnable {
            result = self.searchResult[indexPath.row]
        }
        foodItemDetailsVC.objfoodItemDetailsVC = result
        self.navigationController?.pushViewController(foodItemDetailsVC, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            isSearchEnable = false
        } else {
            isSearchEnable = true
            searchResult = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        self.foodsTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
}
