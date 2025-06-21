//
//  CartVC.swift
//  GoSnabby
//
//  Created by Abdullah on 2/21/21.
//

import UIKit
import iOSDropDown

class CartVC: BaseVC {

    @IBOutlet weak var paypalViewCont: UIView! {
        didSet{
            paypalViewCont.borderWidth = 0.5
            paypalViewCont.borderColor = UIColor.lightGray
            paypalViewCont.layer.cornerRadius = paypalViewCont.frame.height / 2
            
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfSeat: UITextField!
    @IBOutlet weak var amountContainer: NSLayoutConstraint!
    @IBOutlet weak var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var emptyCartIndicator: UIImageView! {
        didSet {
            emptyCartIndicator.isHidden = true
        }
    }
    @IBOutlet weak var purchasePrice: UILabel!
    @IBOutlet weak var ConveniencePrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var lblDepartment: DropDown!{
        didSet {
            self.lblDepartment.allowsEditingTextAttributes = false
        }
    }
    @IBOutlet weak var lblEvent: DropDown!{
        didSet {
            self.lblDepartment.allowsEditingTextAttributes = false
        }
    }
    @IBOutlet weak var departmentContainer: UIView!
    @IBOutlet weak var DepartmentlistView: UIView!
    
    @IBOutlet weak var seatNumberField: UIButton!
    @IBOutlet weak var pickUpField: UIButton!
    @IBOutlet weak var CurbeSideField: UIButton!
    
    @IBOutlet weak var seatNbContainer: UIStackView!
    
    @IBOutlet weak var carModelContainer: UIStackView!
    @IBOutlet weak var carModelMuberField: UITextField!
    
    @IBOutlet weak var enterParkingNoContainer: UIStackView!
    @IBOutlet weak var parkingNoField: UITextField!
    
    @IBOutlet weak var departContainer: UIStackView!
    @IBOutlet weak var cellNoContainer: UIView!
    
    @IBOutlet weak var stackOptHeight: NSLayoutConstraint!
    
    @IBOutlet weak var applicableContainer: UIStackView!
    @IBOutlet weak var applicablefield: UITextField!
    
    var selectDeptId = "-1"
    var selectEventIndex = -1
    var itemInCard: [FoodModel]? = nil
    var departmentList: [DepartmentModel]? = [DepartmentModel]()
    var eventList: [EventModel]? = [EventModel]()
    var selectedOptions = 1
    
    var schoolTax = ""
    var price: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tfPhone.delegate = self
        self.tfPhone.tag = -100
    }
   
    override func viewWillAppear(_ animated: Bool) {
        let dict = UserDefaults.standard.object(forKey: "SchoolTax") as? [String: String] ?? [:]
        schoolTax = dict["sales_tax"] ?? "0"
        itemInCard = DataManager.sharedInstance.getItems()
        tableView.reloadData()
        self.TabbarHide(status: false)
        self.navigationClear()
        self.NavigationHide(status: true)
        DepartmentlistView.isHidden = true
        
        getTotalAmount()
        getDepartment()
        getEvent()
        self.tfPhone.text = ""
        
        applicableContainer.isHidden = true
        carModelContainer.isHidden = true
        enterParkingNoContainer.isHidden = true
        
        setDefaultView()
        setUpHeight(tag: (selectedOptions - 1))
        tfPhone.text = DataManager.sharedInstance.user?.phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        
    }
    
    func getDepartment() {
        
        self.showLoading()
        var params = [String : AnyObject]()
        params["school_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        departmentList = [DepartmentModel]()
        
        NetworkManager.GetAPI(jsonParam: params, WebServiceName: APIName.getDepartments) { (pStatus, pMsg, pData) in
            self.hideLoading()
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {

                   
                    
                        if let arrayDummy = dataMain["data"] as? [[String : Any]] {
                            for objMain in arrayDummy {
                                self.departmentList?.append(DepartmentModel.init(fromDictionary:objMain))
                            }
                            DispatchQueue.main.async {
                                self.getDropDownList()
                            }
                            
                        }else{
                            if let dataMessage = dataMain["message"] as? String {
                                self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
                            }
                            
                        }
                    
                } else {
                    if let dataMessage = dataMain["message"] as? String {
                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
                    }
                }
                self.hideLoading()
            }
        }
        
    }
    
    func getEvent() {
        
        self.showLoading()
        var params = [String : AnyObject]()
        params["school_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        eventList = [EventModel]()
        
        NetworkManager.GetAPI(jsonParam: params, WebServiceName: APIName.getEvent) { (pStatus, pMsg, pData) in
            self.hideLoading()
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {

                   
                    
                        if let arrayDummy = dataMain["data"] as? [[String : Any]] {
                            for objMain in arrayDummy {
                                self.eventList?.append(EventModel.init(fromDictionary:objMain))
                            }
                            DispatchQueue.main.async {
                                self.getEventList()
                            }
                            
                        }else{
                            if let dataMessage = dataMain["message"] as? String {
                                self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
                            }
                            
                        }
                    
                } else {
                    if let dataMessage = dataMain["message"] as? String {
                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
                    }
                }
                self.hideLoading()
            }
        }
        
    }
    
    func getDropDownList() {
        
        let filterDropDown = departmentList?.map({ (department) -> String in
            return department.depName
        })
        lblDepartment.optionArray = filterDropDown ?? []
        lblDepartment.rowHeight = 44
        lblDepartment.didSelect { text, index, id in
            print(index,id)
            self.lblDepartment.text = text
           self.selectDeptId = self.departmentList?[index].id ?? "-1"
        }
        
    }
    
    func getEventList() {
                
        let filterDropDown = eventList?.map({ (event) -> String in
            return event.title
        })
        lblEvent.optionArray = filterDropDown ?? []
        lblEvent.rowHeight = 44
        lblEvent.didSelect { text, index, id in
            print(index,id)
            self.lblEvent.text = text
           self.selectEventIndex = index
        }
        
    }
    
    @IBAction func payNowAction(_ sender: Any) {
        print("payNowAction ")
        
        if !emptyCartIndicator.isHidden {
            self.ShowErrorAlert(message: "Please add item in cart", AlertTitle: "")
            return
        }
        
        if selectedOptions == 1 {
            if self.tfSeat.text!.count == 0 {
                self.ShowErrorAlert(message: "Please add seat number", AlertTitle: "")
                return
            }
            guard  selectDeptId != "-1" else {
                self.ShowErrorAlert(message: "Please Select Department" , AlertTitle: "")
                return
            }
            if self.tfPhone.text!.count != 14 {
                self.ShowErrorAlert(message: "Please enter 10 digit phone number")
                return
            }
            
        } else if selectedOptions == 2 {
            guard  selectDeptId != "-1" else {
                self.ShowErrorAlert(message: "Please Select Department" , AlertTitle: "")
                return
            }
            if self.tfPhone.text!.count != 14 {
                self.ShowErrorAlert(message: "Please enter 10 digit phone number")
                return
            }
            
        } else {
            guard let vehicalColor = carModelMuberField.text, !vehicalColor.isEmpty, let model = parkingNoField.text, !model.isEmpty else {
                self.ShowErrorAlert(message: "Please fill all fields." , AlertTitle: "")
                return
            }

            guard  selectDeptId != "-1" else {
                self.ShowErrorAlert(message: "Please Select Department" , AlertTitle: "")
                return
            }
            if self.tfPhone.text!.count != 14 {
                self.ShowErrorAlert(message: "Please enter 10 digit phone number")
                return
            }
        }
//        guard  lblEvent.text != "" else {
//            self.ShowErrorAlert(message: "Please Select Event" , AlertTitle: "")
//            return
//        }
//
        
        if DataManager.sharedInstance.user?.phone == "" {
            openAlertForPhoneNo()
        }else if DataManager.sharedInstance.getPermanentlySavedUser()!.stripe_customer_id != "" {
            oderNow()
        } else {
            let storyboard = UIStoryboard(name: "AddCard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddCard")
            self.present(vc, animated: true)
        }
        
        
    }
    
    func openAlertForPhoneNo() {
        
        let alertForInfoVC = self.GetView(nameViewController: "AlertForInfoVC", nameStoryBoard: "BottomTabbar" ) as! AlertForInfoVC
        if DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes" || DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes"  {
            alertForInfoVC.hideName = false
        }
        alertForInfoVC.modalPresentationStyle = .overCurrentContext
        self.present(alertForInfoVC, animated: true)
        
    }

    
    @IBAction func selectedOptionAction(_ sender: UIButton) {
        setDefaultView()
        setUpHeight(tag: sender.tag)
    }
    
    func setUpHeight(tag: Int){
        if tag == 0 {
            selectedOptions = 1
            setHeight(scrollViewHeight: 992, cartContainerHeight: 310, contentHeight: 494)
            seatNumberField.setImage(UIImage(named: "icons8-unchecked_radio_button"), for: .normal)
            applicableContainer.isHidden = true
            carModelContainer.isHidden = true
            enterParkingNoContainer.isHidden = true
            
        } else if tag == 1{
            selectedOptions = 2
            setHeight(scrollViewHeight: 912, cartContainerHeight: 310, contentHeight: 404)
            pickUpField.setImage(UIImage(named: "icons8-unchecked_radio_button"), for: .normal)
            applicableContainer.isHidden = true
            carModelContainer.isHidden = true
            enterParkingNoContainer.isHidden = true
            seatNbContainer.isHidden = true
        } else {
            selectedOptions = 3
            setHeight(scrollViewHeight: 1174, cartContainerHeight: 310, contentHeight: 666)
            CurbeSideField.setImage(UIImage(named: "icons8-unchecked_radio_button"), for: .normal)
            seatNbContainer.isHidden = true
        }
    }
    
    func setHeight(scrollViewHeight: CGFloat, cartContainerHeight: CGFloat, contentHeight: CGFloat){
        amountContainer.constant = cartContainerHeight
        stackOptHeight.constant = contentHeight
        viewContainerHeight.constant = scrollViewHeight
    
    }
    
    func setDefaultView() {
        
        seatNumberField.setImage(UIImage(named: "icons8-circled"), for: .normal)
        pickUpField.setImage(UIImage(named: "icons8-circled"), for: .normal)
        CurbeSideField.setImage(UIImage(named: "icons8-circled"), for: .normal)
        
        seatNbContainer.isHidden = false
        applicableContainer.isHidden = false
        carModelContainer.isHidden = false
        enterParkingNoContainer.isHidden = false
        departContainer.isHidden = false
        cellNoContainer.isHidden = false
        
    }
    
    func oderNow() {

        print("oderNow ==>")
        var productIds: [Int] = []
        var productPrices: [String] = []
        var productQuantity: [Int] = []
        _ = itemInCard?.compactMap({ (item) -> FoodModel in
            productIds.append(Int(item.id)!)
            productPrices.append(item.price)
            productQuantity.append(Int(item.quantity)!)
            return item
        })

        self.showLoading()
        var param = [String : AnyObject]()
        
//        let priceArray = totalPrice.text?.split(separator: "+")
        param["school_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        param["user_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.id as AnyObject
        param["phone_number"] = self.tfPhone.text! as AnyObject
        
        param["amount"] = purchasePrice.text as AnyObject // priceArray?[0].trimmingCharacters(in: .whitespaces) as AnyObject
        param["amount_charge"] = ConveniencePrice.text as AnyObject
//        if priceArray?[1] != nil {
//            param["amount_charge"] =  priceArray?[1].trimmingCharacters(in: .whitespaces) as AnyObject
//        }
        
        param["department_id"] = selectDeptId as AnyObject
        param["product_data[]"] =  "\(productIds)"  as AnyObject
        param["num_product[]"] = "\(productQuantity)" as AnyObject
        param["seat_number"] = self.tfSeat.text! as AnyObject
        param["order_case"] = "\(selectedOptions)" as AnyObject
        if DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes" || DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes"  {
            param["orgnizer_name"] = DataManager.sharedInstance.user?.user_name as AnyObject//
        }else {
            param["orgnizer_name"] = "" as AnyObject//
        }
        
        if selectedOptions == 1 {
            param["order_case_description"] = "Seat number: " + tfSeat.text! as AnyObject
        } else if selectedOptions == 2 {
            param["order_case_description"] = "pick up" as AnyObject
        } else {
            if(self.applicablefield.text! != "") {
                param["order_case_description"] = "Parking Space: \(self.applicablefield.text!)" + ", " + "Vehicle Color:  \(self.carModelMuberField.text!)" + ", " + "Vehicle Model: \(self.parkingNoField.text!)" as AnyObject
            } else {
                param["order_case_description"] =  "Vehicle Color: \(self.carModelMuberField.text!)" + ", " + "Vehicle Model :\(self.parkingNoField.text!)" as AnyObject
            }
        }
        if (selectEventIndex != -1) {
            param["event_id"] = eventList?[selectEventIndex] as AnyObject
            param["title"] = eventList?[selectEventIndex] as AnyObject
        }
       
        let actualTax =  (Float(schoolTax)! * Float(price)) / 100
        param["amount_charge_actual"] = actualTax as AnyObject
        param["product_price_actual"] = price as AnyObject
        param["product_prices[]"]  = "\(productPrices)" as AnyObject
       
        print("Params-->> 6666", param)
        
        NetworkManager.PostAPI(jsonParam: param, WebServiceName: APIName.addFoodOrder) { (pStatus, pMsg, pData) in

            print(pStatus)
            print(pMsg)
            print(pData)
            self.hideLoading()
            
            if let dataMain = pData as? [String : Any] {

                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    self.hideLoading()
                    UserDefaults.standard.removeObject(forKey: "cart")
                    
                    let ordercomplete = self.GetView(nameViewController:  "OrderCompletedVC", nameStoryBoard: "OrderCompleted") as! OrderCompletedVC
                    
                    let arrayDummy = dataMain["data"] as? [String : Any]
                    print(arrayDummy?["id"])
                    if arrayDummy?["id"] != nil {
                    ordercomplete.orderID = arrayDummy?["id"] as! Int
                    self.navigationController?.pushViewController(ordercomplete, animated: true)
                    } else {
                        self.ShowErrorAlert(message: dataMain["message"] as? String ?? "Some thing went wrong")
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

extension CartVC:  UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.itemInCard?.count == 0 || self.itemInCard?.count == nil {
            emptyCartIndicator.isHidden = false
        } else {
            emptyCartIndicator.isHidden = true
        }
        return itemInCard?.count ?? 0
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let itemListCell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
         itemListCell.removeItem.tag = indexPath.row
         itemListCell.removeItem.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
         
         itemListCell.addItem.tag = indexPath.row
         itemListCell.addItem.addTarget(self, action: #selector(addItem), for: .touchUpInside)
         
         itemListCell.minItem.tag = indexPath.row
         itemListCell.minItem.addTarget(self, action: #selector(minItem), for: .touchUpInside)
         
         itemListCell.itemCount.tag = indexPath.row
        
//         itemListCell.itemCount.delegate = self
        itemListCell.itemCount.isEnabled = false
         itemListCell.itemName.text = itemInCard?[indexPath.row].name
         itemListCell.itemDesc.text = itemInCard?[indexPath.row].detail
         itemListCell.price.text = String(((itemInCard?[indexPath.row].price)!))
        if self.itemInCard?[indexPath.row].image == nil {
            itemListCell.itemImage.image = UIImage(named: "imagePlaceholder")
        } else {
            self.downloadImage(imgview: itemListCell.itemImage, URL: kBaseItemImageURL + (self.itemInCard?[indexPath.row].image)!)
        }
        
        let quantity: Int = Int(itemInCard![indexPath.row].quantity ) ?? 1
        itemListCell.itemCount.text = String(describing: quantity )
        
        itemListCell.selectionStyle = .none
         return itemListCell
     }
     
    @objc func removeItem(sender:UIButton) {
        let index = sender.tag
        itemInCard?.remove(at: index)
        DataManager.sharedInstance.cartItemsList = itemInCard
        DataManager.sharedInstance.saveItems()
        getTotalAmount()
        
        NotificationCenter.default.post(name: updateCartNoti , object: self, userInfo: nil)

        tableView.reloadData()
    }
     
    @objc func addItem(sender:UIButton) {
        let index = sender.tag
        let count  = Int(itemInCard?[index].quantity ?? "1")
        itemInCard?[index].quantity = String((count ?? 1) + 1)
        DataManager.sharedInstance.cartItemsList = itemInCard
        DataManager.sharedInstance.saveItems()
        getTotalAmount()

        NotificationCenter.default.post(name: updateCartNoti , object: self, userInfo: nil)

        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
     }
     
    @objc func minItem(sender:UIButton) {
        
        let index = sender.tag
        let count  = Int(itemInCard?[index].quantity ?? "1")
        if count! > 1 {
            itemInCard?[index].quantity = String((count ?? 1) - 1)
            DataManager.sharedInstance.cartItemsList = itemInCard
            DataManager.sharedInstance.saveItems()
            getTotalAmount()
            NotificationCenter.default.post(name: updateCartNoti , object: self, userInfo: nil)
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
        }
         
    }
    
    func getTotalAmount() {
        price = 0.0
        _ = itemInCard?.compactMap({ (item) -> FoodModel in
            price = price + ((Double(item.price) ?? 0) * (Double(item.quantity) ?? 1))
            return item
        })
        totalPrice.text = String(format: "%.2f",price)
        
        if schoolTax != "0" {
            let taxes = (Float(schoolTax)! * Float(price)) / 100
            purchasePrice.text = String(format: "%.2f",price)
            ConveniencePrice.text = String(format: "%.2f",taxes)
            totalPrice.text = String(format: "%.2f", (price + Double(taxes)))
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
         return UIView()
     }
     
 }

extension CartVC : UITextFieldDelegate {
     func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag != -100 {
            print(textField.text)
            self.itemInCard?[textField.tag].quantity = "\(String(describing: Int(textField.text ?? "1")))"
            DataManager.sharedInstance.cartItemsList = self.itemInCard
            DataManager.sharedInstance.saveItems()
            getTotalAmount()
            NotificationCenter.default.post(name: updateCartNoti , object: self, userInfo: nil)
             tableView.reloadRows(at: [IndexPath(item: textField.tag, section: 0)], with: .automatic)
        }
     }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField.tag == -100 {
            guard let text = textField.text else { return false }
            if str.count > 14{
                return false
            }
            tfPhone.text = text.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        }
        return true
    }
    
    

    
}
extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
