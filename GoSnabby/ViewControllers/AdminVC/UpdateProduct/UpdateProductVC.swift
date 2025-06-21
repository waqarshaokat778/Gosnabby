//
//  UpdateProductVC.swift
//  GoSnabby
//
//  Created by Abdullah on 6/21/21.
//

import UIKit
import iOSDropDown

class UpdateProductVC: BaseVC {
    //Set the tag for get the values
    let nameTag = -111
    let detailTag = -112
    let descriptionTag = -113
    let typeTag = -114
    let priceTag = -115
    let availableQuantityTag = -116
    
    let lunchWeekTag = -100
    

    @IBOutlet weak var foodDetailList: UITableView!
    
    let lunch = "lunch"
    let item = "food"
    var isnewLunch = false
    
//    let cateDropDown = DropDown()
//    let itemListDropDown = DropDown()
    var isForLunch: String? = nil
    var barCode: String = ""
    
    let calendar = NSCalendar.current

    var arrayCategory = [CategoryModel]()
    var arrayFood = [FoodModel]()
    var productDetail: ProductDetailModel? = nil
    var lunchDetail: LunchDetailModel? = nil
    
    
    var isImageChange = false
    var selectedImage: UIImage? = nil
    var selectCategorytId: String = "-1"
    var imagePicker = UIImagePickerController()
    
    var foodNameField = ""
    var foodDetailField = ""
    var foodDescriptionField  = ""
    var foodTypeField  = ""
    var foodPriceField  = ""
    var foodItemAvailableField = ""
    
    var dealId = ""
    var lunchDate: String? =  nil
    var lunchQuantity: [Int] = []
    var lunchDealProducts: [Int] = []
    
    override func viewDidLoad() {
        registerNibs()
        foodDetailList.delegate = self
        foodDetailList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if barCode != "" {
            checkProductExist(barCode)
//            if isForLunch == lunch {
                getFoodList()
//            } else if isForLunch == item  {
                getCategoryList()
//            }
        }
        
//        itemListDropDown.selectionAction = { (index: Int, item: String) in
//            self.isnewLunch = false
//            self.lunchDetail?.productdetail?[self.itemListDropDown.tag].name = item
//            self.lunchDetail?.productdetail?[self.itemListDropDown.tag].id =  Int(self.arrayFood[self.itemListDropDown.tag].id)
//            
//            self.lunchDealProducts[self.itemListDropDown.tag] = Int(self.arrayFood[index].id)!
//            self.foodDetailList.reloadSections([3], with: .automatic)
//       }
    }
    
    func registerNibs() {
        
        self.foodDetailList.register(UINib.init(nibName: "productImageEditCell", bundle: nil), forCellReuseIdentifier: "ProductImageEditCell")
        self.foodDetailList.register(UINib.init(nibName: "FoodItemUpdateCell", bundle: nil), forCellReuseIdentifier: "FoodItemUpdateCell")
        self.foodDetailList.register(UINib.init(nibName: "UpdateBtnCell", bundle: nil), forCellReuseIdentifier: "UpdateBtnCell")
        
        self.foodDetailList.register(UINib.init(nibName: "LunchItemEdit", bundle: nil), forCellReuseIdentifier: "LunchItemEditCell")
        self.foodDetailList.register(UINib.init(nibName: "LunchItemEditField", bundle: nil), forCellReuseIdentifier: "LunchItemEditFieldCell")
        
        self.foodDetailList.register(UINib.init(nibName: "Heading", bundle: nil), forCellReuseIdentifier: "HeadingCell")
        
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func checkProductExist(_ barcode: String)  {
        self.showLoading()
        
        var params = [String : AnyObject]()
        params["barcode"] = barcode as AnyObject
        params["school_id"] = DataManager.sharedInstance.getPermanentlySavedAdmin()?.id as AnyObject
        print("Params==>", params)
        
        NetworkManager.PostAPI(jsonParam: params, WebServiceName: APIName.checkItemAgainstCode) {
            (pStatus, pMsg, pData) in
            print("Response ==>", pData)
            
            self.lunchDealProducts = []
            self.lunchQuantity = []
            
            self.hideLoading()
            self.productDetail = nil
            if let dataMain = pData as? [String : Any] {
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    //client want to remove lunch
                    self.isForLunch = dataMain["is_food"] as? String
                    if self.isForLunch == nil {
                        let alertController = UIAlertController(title: nil, message: "Item not found, would you like to add a new product?", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.isForLunch = self.item
                            DispatchQueue.main.async {
                                self.foodDetailList.reloadData()
                            }
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
//                            self.isForLunch = self.lunch
//                            self.isnewLunch = true
//                            let defaultValue = ProductDetailModel(id: 0, name: "", isLike: 0, description: "", availableItems: "", image: "", price: "", categoryID: 0, updatedAt: "", createdAt: "", schoolID: 0, productType: "", detail: "", softDelete: 1, barcode: "", quantity: 1)
//                            self.lunchDetail = LunchDetailModel(id: -1, schoolID: -1, name: "", price: "0", dateFrom: "", dateTo: "", weekNumber: "", dealImage: "", detail: "", description: "", availableDeals: 0, createdAt: "", updatedAt: "", barcode: self.barCode, productdetail: [defaultValue])
//                            self.lunchDealProducts.append(0)
//                            self.lunchQuantity.append(1)
//                            DispatchQueue.main.async {
//                                self.foodDetailList.reloadData()
//                            }
                        }

                        // Add the actions
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)

                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        if let arrayDummy = dataMain["food_detail"] as? [String : Any] {
                            do {
                                let json = try JSONSerialization.data(withJSONObject: arrayDummy)
                               
                                let resultModel = try JSONDecoder().decode(ProductDetailModel.self, from: json)
                                print("productDetail: ",resultModel)
                                DispatchQueue.main.async {
                                    self.productDetail = resultModel
                                    self.foodDetailList.reloadData()
                                }
                            } catch let myJSONError {
                               print(myJSONError)
                            }
                        }
                        if let arrayDummy = dataMain["lunch_detail"] as? [String : Any] {
                            do {
                                let json = try JSONSerialization.data(withJSONObject: arrayDummy)
                               
                                let resultModel = try JSONDecoder().decode(LunchDetailModel.self, from: json)
                                print("productDetail: ",resultModel)
                                
                                if resultModel.productdetail != nil {
                                    for index in resultModel.productdetail! {
                                        self.lunchDealProducts.append( index.id!)
                                        self.lunchQuantity.append( index.quantity!)
                                    }
                                }
                                
                                DispatchQueue.main.async {
                                    self.dealId =  String(describing: arrayDummy["id"] as! Int)
                                    
                                    
                                    self.lunchDetail = resultModel
                                    self.foodDetailList.reloadData()
                                }
                            } catch let myJSONError {
                               print(myJSONError)
                            }
                        }
                    }
                }
                self.hideLoading()
            }
        }
    }
    
    func getCategoryList() {
        
        print("Calling getCategoryList...")
        self.showLoading()
        arrayCategory.removeAll()
        arrayCategory = [CategoryModel]()
        var newPAram = [String : AnyObject]()
        newPAram["school_id"] = DataManager.sharedInstance.getPermanentlySavedAdmin()?.id as AnyObject
        print("newPAram", newPAram)
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
                        
                        DispatchQueue.main.async {
                            self.foodDetailList.reloadData()
                        }
                    }
                    self.hideLoading()
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
        newPAram["school_id"] = DataManager.sharedInstance.getPermanentlySavedAdmin()?.id as AnyObject
        NetworkManager.GetAPI(jsonParam: newPAram, WebServiceName: APIName.get_all_like_unlike_product_list) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    if let arrayDummy = dataMain["data"] as? [String : Any] {
                        let data = arrayDummy["products"] as! [[String:Any]]
                        for objMain in data {
                            self.arrayFood.append(FoodModel.init(fromDictionary:objMain))
                        }
                        DispatchQueue.main.async {
                            
                        }
                        print("arrayFood.count ===> " )
                        print(self.arrayFood.count)
                        
                    }
                    self.hideLoading()
                }
            }
        }
    }
    
    func updateProduct(){
        print(IndexPath(row: 1, section: 0))
        
        var newPAram = [String : AnyObject]()
        newPAram["school_id"] = DataManager.sharedInstance.getPermanentlySavedAdmin()?.id as AnyObject
        
        newPAram["name"] = foodNameField as AnyObject
        newPAram["detail"] = foodDetailField as AnyObject
        newPAram["description"] = foodDescriptionField as AnyObject
        newPAram["product_type"] = foodTypeField as AnyObject
        newPAram["price"] = foodPriceField as AnyObject
        newPAram["available_items"] = foodItemAvailableField as AnyObject
       
        newPAram["category_id"] = selectCategorytId as AnyObject
        newPAram["barcode"] = barCode as AnyObject
       
            
    
        print("<==== newPAram ===>")
        print(newPAram)
        self.showLoading()
            
        NetworkManager.PostUserImageAPI(jsonParam: newPAram, WebServiceName: "update_product", imageMain: selectedImage, "item_image") { (pStatus, pMsg, pData) in
            self.hideLoading()

            if let dataMain = pData as? [String : Any] {
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    // For Object
                    if let dataObj = dataMain["data"] as? [String : AnyObject] {
                        self.hideLoading()

                       self.ShowSuccessAlert(message: dataMain["message"] as! String , AlertTitle: "")
                       
                    }else {
                        self.hideLoading()
                        if let dataMessage = dataMain["message"] as? String {
                            self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
                        }else{
                            self.ShowErrorAlert(message: "Something wrong" , AlertTitle: "")
                        }
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
    
    func updateLunchDetail(){
        
        var newPAram = [String : AnyObject]()
        newPAram["school_id"] = DataManager.sharedInstance.getPermanentlySavedAdmin()?.id as AnyObject
        newPAram["barcode"] = barCode as AnyObject
        newPAram["name"] = foodNameField as AnyObject
        newPAram["detail"] = foodDetailField as AnyObject
        newPAram["description"] = foodDescriptionField as AnyObject
        newPAram["deal_price"] = foodPriceField as AnyObject
        newPAram["available_deals"] = foodItemAvailableField as AnyObject
        
        if dealId != "" {
            newPAram["deal_id"] = dealId as AnyObject
        }
        
        newPAram["deal_products"] = "\( lunchDealProducts)" as AnyObject
        newPAram["quantity"] = "\(lunchQuantity)" as AnyObject
        
        let dateweek = calendar.component(.weekOfYear, from: lunchDate?.returnDateString(inputformat: "yyyy-MM-dd") ?? Date())
        var year = lunchDate?.dateString(inputformat: "yyyy-MM-dd", outputformat: "yyyy")
        if year == "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            year = formatter.string(from: Date())
        }
        newPAram["selectedweek"] =  "\(year!)" + "-W" + "\(dateweek)" as AnyObject
        
        
        print("<==== newPAram ===>")
        print(newPAram)
        
        self.showLoading()
            
        NetworkManager.PostUserImageAPI(jsonParam: newPAram, WebServiceName: "update_lunch_barcode", imageMain: selectedImage, "deal_image") { (pStatus, pMsg, pData) in
            self.hideLoading()

            if let dataMain = pData as? [String : Any] {
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    // For Object
                    if let dataObj = dataMain["data"] as? [String : AnyObject] {
                        self.hideLoading()

                       self.ShowSuccessAlert(message: dataMain["message"] as! String , AlertTitle: "")
                       
                    }else {
                        self.hideLoading()
                        if let dataMessage = dataMain["message"] as? String {
                            self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
                        }else{
                            self.ShowErrorAlert(message: "Something wrong" , AlertTitle: "")
                        }
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

extension UpdateProductVC:  UITableViewDelegate, UITableViewDataSource {
    
    //Mark Table delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isForLunch == lunch {
            return 6
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isForLunch == lunch {
            if section == 3 {
                return lunchDetail?.productdetail?.count ?? 0
            }
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isForLunch == lunch {
            switch indexPath.section {
            case 0:
                return updateImageFood(tableView, indexPath: indexPath)
            case 1:
                return lunchFieldDetial(tableView, indexPath: indexPath)
            case 2:
                return lunchItemHeader(tableView, indexPath: indexPath)
            case 3:
                return lunchItemDetial(tableView, indexPath: indexPath)
            case 4:
                return addLunchItem(tableView, indexPath: indexPath)
            case 5:
                return updateProduct(tableView, indexPath: indexPath)
            default:
                return UITableViewCell()
            }
          
        }
        switch indexPath.row {
        case 0:
            return updateImageFood(tableView, indexPath: indexPath)
        case 1:
            return foodDetial(tableView, indexPath: indexPath)
        case 2:
            return updateProduct(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    //Mark update Food
    func updateImageFood(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let productImageCell = tableView.dequeueReusableCell(withIdentifier: "ProductImageEditCell", for: indexPath) as! ProductImageEditCell
        if isImageChange {
            productImageCell.productImage.image = selectedImage
        } else {
            if isForLunch == lunch {
                print(kBaseItemImageURL , (lunchDetail?.dealImage ?? ""))
                self.downloadImage(imgview: productImageCell.productImage, URL: kBaseLunchImageURL + (lunchDetail?.dealImage ?? "") )
            } else {
                self.downloadImage(imgview: productImageCell.productImage, URL: kBaseItemImageURL + (productDetail?.image ?? "") )
            }
        }
        productImageCell.selectionStyle = .none
        return productImageCell
    }
    
    func foodDetial(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let foodDetial = tableView.dequeueReusableCell(withIdentifier: "FoodItemUpdateCell", for: indexPath) as! FoodItemUpdateCell
        
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showCatListAction))
//        foodDetial.foodCategoryField.addGestureRecognizer(tap)
//        foodDetial.foodCategoryField.allowsEditingTextAttributes = false
//        foodDetial.foodCategoryField.isUserInteractionEnabled = true
        
        if productDetail != nil {
            setupFieldForFood(foodDetial, tableView, indexPath)
        }
        
        setupFieldTagsForFood(foodDetial, tableView, indexPath)
        
        let selectedcat = arrayCategory.filter { (catagory) -> Bool in
            return String(catagory.id) == String((productDetail?.categoryID) ?? -1)
        }
        if selectedcat.count > 0 {
            
            foodDetial.foodCategoryField.text = selectedcat[0].name
            self.selectCategorytId = selectedcat[0].id
        }
        
            
//
//        cateDropDown.anchorView = foodDetial.foodCategoryField
//        cateDropDown.cellHeight = 40
//        cateDropDown.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        cateDropDown.selectionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
        
        let filterDropDown = arrayCategory.map({ (category) -> String in
            return category.name
        })
//        cateDropDown.dataSource = filterDropDown
//        cateDropDown.selectionAction = { (index: Int, item: String) in
//            foodDetial.foodCategoryField.text = item
//            self.selectCategorytId = self.arrayCategory[index].id
//        }
        
        foodDetial.selectionStyle = .none
        return foodDetial
    }
    
    func setupFieldForFood(_ cell: FoodItemUpdateCell, _ tableView: UITableView,_ indexPath: IndexPath) {
        cell.foodNameField.text = productDetail?.name
        cell.foodDetailField.text = productDetail?.detail
        cell.foodDescriptionField.text = productDetail?.description
        cell.foodTypeField.text = productDetail?.productType
        cell.foodPriceField.text = productDetail?.price
        cell.foodItemAvailableField.text = productDetail?.availableItems
        
        
        foodNameField = productDetail?.name ?? ""
        foodDetailField = productDetail?.detail ?? ""
        foodDescriptionField = productDetail?.description ?? ""
        foodTypeField = productDetail?.productType ?? ""
        foodPriceField = productDetail?.price ?? ""
        foodItemAvailableField = productDetail?.availableItems ?? ""
        
        
       
    }
    
    func setupFieldTagsForFood(_ cell: FoodItemUpdateCell, _ tableView: UITableView,_ indexPath: IndexPath) {
        cell.foodNameField.delegate = self
        cell.foodNameField.tag = nameTag
        cell.foodDetailField.delegate = self
        cell.foodDetailField.tag = detailTag
        cell.foodDescriptionField.delegate = self
        cell.foodDescriptionField.tag = descriptionTag
        cell.foodTypeField.delegate = self
        cell.foodTypeField.tag = typeTag
        cell.foodPriceField.delegate = self
        cell.foodPriceField.tag = priceTag
        cell.foodItemAvailableField.delegate = self
        cell.foodItemAvailableField.tag = availableQuantityTag
    }
    
//    @objc func showCatListAction(_ tap: UITapGestureRecognizer) {
//        cateDropDown.show()
//    }
    
    func updateProduct(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let updateProduct = tableView.dequeueReusableCell(withIdentifier: "UpdateBtnCell", for: indexPath) as! UpdateBtnCell
        updateProduct.updateProductBtn.setTitle("Update", for: .normal)
        updateProduct.updateProductBtn.isUserInteractionEnabled = false
//        updateProduct.updateProductBtn.addTarget(self, action:  #selector(updateFoodItems) , for: .touchUpInside)
        updateProduct.selectionStyle = .none

        return updateProduct
    }
    
    //Mark update Lunch
    
    func addLunchItem(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let addItem = tableView.dequeueReusableCell(withIdentifier: "UpdateBtnCell", for: indexPath) as! UpdateBtnCell
        addItem.updateProductBtn.setTitle("Add Item", for: .normal)
        addItem.updateProductBtn.isUserInteractionEnabled = false
//        addItem.updateProductBtn.addTarget(self, action: #selector(addProductItem) , for: .touchUpInside)
        return addItem
    }
    
     func addProductItem() {
        self.lunchDealProducts.append(0)
        self.lunchQuantity.append(1)
        
        let defaultValue = ProductDetailModel(id: 0, name: "", isLike: 0, description: "", availableItems: "", image: "", price: "", categoryID: 0, updatedAt: "", createdAt: "", schoolID: 0, productType: "", detail: "", softDelete: 1, barcode: "", quantity: 1)
        
        lunchDetail?.productdetail?.append(defaultValue)
        foodDetailList.reloadSections([3], with: .automatic)
    }
    
    func lunchItemHeader(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let headerView = self.foodDetailList.dequeueReusableCell(withIdentifier: "HeadingCell" ) as! HeadingCell
        headerView.headingLable.text = "Item Detail"
        headerView.selectionStyle = .none
        return headerView
    }
    
    func lunchFieldDetial(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LunchItemEditFieldCell", for: indexPath) as! LunchItemEditFieldCell
        cell.lunchNameField.text = lunchDetail?.name
        cell.lunchDetailField.text = lunchDetail?.detail
        cell.lunchDescriptionField.text = lunchDetail?.description

        let dateStartPlaceholder = Date().startOfWeek().dateByAddingDays(8)
        let dateEndPlaceholder = dateStartPlaceholder.dateByAddingDays(6)
        
        var startLunchDate = ""
        var endLunchDate = ""
        if !isnewLunch {
             startLunchDate = lunchDetail?.dateTo?.dateString(inputformat: "yyyy-MM-dd HH:mm:ss", outputformat: "yyyy-MM-dd") ?? dateStartPlaceholder.dateString("yyyy-MM-dd")
             endLunchDate = lunchDetail?.dateFrom?.dateString(inputformat: "yyyy-MM-dd HH:mm:ss", outputformat: "yyyy-MM-dd") ?? dateEndPlaceholder.dateString("yyyy-MM-dd")
        } else {
            startLunchDate =  dateStartPlaceholder.dateString("yyyy-MM-dd")
            endLunchDate =  dateEndPlaceholder.dateString("yyyy-MM-dd")
        }
       
        if self.lunchDate == nil {
            cell.lunchWeekField.text =  startLunchDate + " to " + endLunchDate
        } else {
            cell.lunchWeekField.text =  self.lunchDate
        }
        
        self.lunchDate = lunchDetail?.dateTo?.dateString(inputformat: "yyyy-MM-dd HH:mm:ss", outputformat: "yyyy-MM-dd")
        if isnewLunch {
            self.lunchDate = startLunchDate
        }
        
        cell.lunchPriceField.text = "\(lunchDetail?.price ?? "0")"
        cell.lunchItemAvailableField.text = String(lunchDetail?.availableDeals ?? 0)

        foodNameField = lunchDetail?.name ?? ""
        foodDetailField = lunchDetail?.detail ?? ""
        foodDescriptionField = lunchDetail?.description ?? ""
        foodTypeField = ""
        foodPriceField = "\(lunchDetail?.price ?? "0")"
        foodItemAvailableField = "\(lunchDetail?.availableDeals ?? 0)"

        cell.lunchNameField.delegate = self
        cell.lunchNameField.tag = nameTag
        cell.lunchDetailField.delegate = self
        cell.lunchDetailField.tag = detailTag
        cell.lunchDescriptionField.delegate = self
        cell.lunchDescriptionField.tag = descriptionTag
        cell.lunchWeekField.delegate = self
        cell.lunchWeekField.tag = lunchWeekTag
        cell.lunchPriceField.delegate = self
        cell.lunchPriceField.tag = priceTag
        cell.lunchItemAvailableField.delegate = self
        cell.lunchItemAvailableField.tag = availableQuantityTag
        
        cell.selectionStyle = .none
        return cell
    }
    
    func lunchItemDetial(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {

        let updateProduct = tableView.dequeueReusableCell(withIdentifier: "LunchItemEditCell", for: indexPath) as! LunchItemEditCell
        let filter = lunchDetail?.productdetail?[indexPath.row]
        
        updateProduct.foodItemNameField.text = filter?.name
        updateProduct.foodItemDetailField.text = String(filter?.quantity ?? 0)
        
        updateProduct.foodItemNameField.delegate = self
        updateProduct.foodItemNameField.tag = indexPath.row
        updateProduct.foodItemDetailField.delegate = self
        updateProduct.foodItemDetailField.tag = indexPath.row
        
        updateProduct.selectionStyle = .none
        updateProduct.viewContainer.borderWidth = 0.4
        updateProduct.viewContainer.borderColor = .lightGray
        updateProduct.viewContainer.cornerRadius = 6
        
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(removeItem(_:)))
        updateProduct.removeFoodImg.addGestureRecognizer(tap)
        updateProduct.removeFoodImg.isUserInteractionEnabled = true
        updateProduct.removeFoodImg.tag = indexPath.row
        
        let changeItemtap = UITapGestureRecognizer.init(target: self, action: #selector(showChangeItemtap))
        updateProduct.foodItemNameField.addGestureRecognizer(changeItemtap)
        updateProduct.foodItemNameField.allowsEditingTextAttributes = false
        updateProduct.foodItemNameField.isUserInteractionEnabled = true
        updateProduct.foodItemNameField.tag = indexPath.row
        
        
//        self.lunchDealProducts.append(String(describing: filter!.id!))
//        self.lunchQuantity.append(String(describing: filter!.quantity!))
//
        
//        itemListDropDown.cellHeight = 40
//        itemListDropDown.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        itemListDropDown.selectionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let filterDropDown = arrayFood.map({ (item) -> String in
            return item.name
        })
//        itemListDropDown.dataSource = filterDropDown
        
        
        return updateProduct
    }
    
    @objc func showChangeItemtap( _ tap: UITapGestureRecognizer){
        let cell = foodDetailList.cellForRow(at: IndexPath(row: tap.view!.tag, section: 3)) as? LunchItemEditCell
//        itemListDropDown.anchorView = cell?.foodItemNameField
//        itemListDropDown.tag = tap.view!.tag
//        itemListDropDown.show()
    }
    
    @objc func removeItem(_ tap: UITapGestureRecognizer) {
        lunchDetail?.productdetail?.remove(at: tap.view!.tag)
        self.lunchDealProducts.remove(at: tap.view!.tag)
        self.lunchQuantity.remove(at: tap.view!.tag)
        foodDetailList.reloadSections([3], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            }
        }
        if isForLunch == lunch {
            if indexPath.section == 4 {
                self.addProductItem()
            } else if indexPath.section == 5 {
                //todo
//                guard let _ = selectedImage else {
//                    self.ShowErrorAlert(message: "Please select image", AlertTitle: "")
//                    return
//                }
                guard  foodNameField != "" else {
                    self.ShowErrorAlert(message: "Please enter lunch name", AlertTitle: "")
                    return
                }
                guard foodDetailField != "" else {
                    self.ShowErrorAlert(message: "Please enter detail", AlertTitle: "")
                    return
                }
                guard foodDescriptionField != "" else {
                    self.ShowErrorAlert(message: "Please enter description", AlertTitle: "")
                    return
                }

                guard lunchDate != nil || lunchDate != "" else {
                    self.ShowErrorAlert(message: "Please select lunch week ", AlertTitle: "")
                    return
                }
                
                guard foodPriceField != "" else {
                    self.ShowErrorAlert(message: "Please enter price", AlertTitle: "")
                    return
                }
                
                guard foodItemAvailableField != "" else {
                    self.ShowErrorAlert(message: "Please enter available items", AlertTitle: "")
                    return
                }
                
                let itemsZeroQuantity = lunchQuantity.filter { (quantity) -> Bool in
                    return quantity == 0
                }

                let itemNullID = lunchDealProducts.filter { (id) -> Bool in
                    return id == 0
                }

                guard lunchDealProducts.count != 0 else {
                    self.ShowErrorAlert(message: "Please add atleast one item ", AlertTitle: "")
                    return
                }
                guard itemNullID.count == 0 else {
                    self.ShowErrorAlert(message: "Please select item", AlertTitle: "")
                    return
                }
                guard itemsZeroQuantity.count == 0 else {
                    self.ShowErrorAlert(message: "Item quantity should not be 0", AlertTitle: "")
                    return
                }
                
                updateLunchDetail()
            }
        } else {
            if indexPath.row == 2{
                //todo
//                guard let _ = selectedImage else {
//                    self.ShowErrorAlert(message: "Please select image", AlertTitle: "")
//                    return
//                }
                guard  foodNameField != "" else {
                    self.ShowErrorAlert(message: "Please enter item name", AlertTitle: "")
                    return
                }
                guard foodDetailField != "" else {
                    self.ShowErrorAlert(message: "Please enter detail", AlertTitle: "")
                    return
                }
                guard foodDescriptionField != "" else {
                    self.ShowErrorAlert(message: "Please enter description", AlertTitle: "")
                    return
                }
                
                guard selectCategorytId != "-1" else {
                    self.ShowErrorAlert(message: "Please select category", AlertTitle: "")
                    return
                }
                
                guard foodTypeField != "" else {
                    self.ShowErrorAlert(message: "Please enter item type", AlertTitle: "")
                    return
                }

                guard foodPriceField != "" else {
                    self.ShowErrorAlert(message: "Please enter price", AlertTitle: "")
                    return
                }
                guard foodItemAvailableField != "" else {
                    self.ShowErrorAlert(message: "Please enter available items", AlertTitle: "")
                    return
                }
                
                updateProduct()
            }
        }
    }
    
//    @objc func updateFoodItems(_ tap: UITapGestureRecognizer) {
//        if isForLunch == lunch {
//            updateLunchDetail()
//        } else {
//            updateProduct()
//        }
//    }
    
}

extension UpdateProductVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField.tag == lunchWeekTag {
            let datePicker = DatePickerDialog.init()

            let dateStart = Date().startOfWeek().dateByAddingDays(8)
            datePicker.show("Choose Date"  , doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: dateStart, minimumDate: dateStart, maximumDate: nil, datePickerMode: .date, timeInterval: 0) { (datChoose) in
                let cell = self.foodDetailList.dequeueReusableCell(withIdentifier: "LunchItemEditFieldCell") as! LunchItemEditFieldCell
                cell.lunchWeekField.text = datChoose?.dateString("yyyy-MM-dd")
                self.lunchDate = cell.lunchWeekField.text
                self.foodDetailList.reloadSections([1], with: .automatic)

            }
            return false
        }

        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("<==== textField.tag ===> ")
        handleFields(textField)
    }
    
    func handleFields(_ textField: UITextField){
        switch textField.tag {
        case nameTag:
            foodNameField = textField.text!
            if isForLunch == lunch {
                self.lunchDetail?.name = textField.text!
            } else {
                self.productDetail?.name = textField.text!
            }
        case detailTag:
            foodDetailField = textField.text!
            if isForLunch == lunch {
                self.lunchDetail?.detail = textField.text!
            } else {
                self.productDetail?.detail = textField.text!
            }
        case descriptionTag:
            foodDescriptionField = textField.text!
            if isForLunch == lunch {
                self.lunchDetail?.description = textField.text!
            } else {
                self.productDetail?.description = textField.text!
            }
        case typeTag:
            foodTypeField = textField.text!
            
        case priceTag:
            foodPriceField = textField.text!
            guard let price = Float(textField.text!) else {
                ShowErrorAlert(message: "Please select valid price")
                return
            }
            if isForLunch == lunch {
                self.lunchDetail?.price = "\(price)"
            } else {
                self.productDetail?.price = textField.text!
            }
        case availableQuantityTag:
            foodItemAvailableField = textField.text!
            guard let items = Int(textField.text!) else {
                ShowErrorAlert(message: "Please select valide price")
                return
            }
            if isForLunch == lunch {
                self.lunchDetail?.availableDeals = items
            } else {
                self.productDetail?.availableItems = textField.text!
            }
        default:
            if let cell = foodDetailList.cellForRow(at: IndexPath(row: textField.tag, section: 3)) as? LunchItemEditCell {
                if cell.foodItemDetailField.text != nil && (Int(cell.foodItemDetailField.text!) != nil) {
                    lunchQuantity[textField.tag] =  Int(cell.foodItemDetailField.text!)!
                    self.lunchDetail?.productdetail?[textField.tag].quantity = Int(cell.foodItemDetailField.text!)!
                    foodDetailList.reloadSections([3], with: .automatic)
                } else {
                    print("foodItemDetailField is nil ")
                }
            }
        }
    }
    
}

extension UpdateProductVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            isImageChange = true
            selectedImage = image
            foodDetailList.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

