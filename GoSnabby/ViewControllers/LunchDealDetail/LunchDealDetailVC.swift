//
//  LunchDealDetailVC.swift
//  GoSnabby
//
//  Created by Abdullah on 3/2/21.
//

import UIKit

class LunchDealDetailVC: BaseVC {
    
    var dealItemList: LunchMeal? = nil
    
    @IBOutlet weak var tfCalendar: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSubname: UILabel!
    @IBOutlet weak var lblDescription: UITextView! {
        didSet {
            lblDescription.isUserInteractionEnabled = false 
        }
    }
    @IBOutlet weak var lblquantity: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
  
    var chooseDate = ""
    var schoolTax = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.tfPhoneNumber.tag = -100
        self.tfPhoneNumber.delegate = self
        self.tfCalendar.delegate = self
        
        let dateStart = Date().startOfWeek().dateByAddingDays(8)
        let dateEnd = dateStart.dateByAddingDays(6)
        
        self.tfCalendar.text = dateStart.dateString("yyyy-MM-dd") + " to " + dateEnd.dateString("yyyy-MM-dd")
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        self.NavigationHide(status: false)
        self.TabbarHide(status: true)
        self.AddBackButton()
        
        self.UpdateTitle(title: dealItemList?.name ?? "", color: UIColor.white)
        pageController.numberOfPages = dealItemList?.deals?.count ?? 0
         let dict = UserDefaults.standard.object(forKey: "SchoolTax") as? [String: String] ?? [:]
        schoolTax = dict["sales_tax"] ?? "0"

        setupField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    func setupField() {
        lblName.text = dealItemList?.name
        lblPrice.text = String(describing: dealItemList!.price!)
        if schoolTax != "0" {
            lblPrice.text = String(describing: dealItemList!.price!) + " + " + schoolTax
        }
        
        lblSubname.text = dealItemList?.detail
        lblDescription.text = dealItemList?.description
    }
    
    @IBAction func AddOneAction(_ sender: Any) {
        let count  = Int(lblquantity.text!)
        lblquantity.text = String((count ?? 1) + 1)
        let price = Float(dealItemList!.price!)! * Float(count! + 1)
         let tax = Float(schoolTax)! * (Float(count! + 1))
         if schoolTax != "0" {
            lblPrice.text = String(format: "%.02f", price) + " + " + "\(tax)"
         } else {
            lblPrice.text = String(format: "%.02f", price)
         }
    }

    @IBAction func lessOneAction(_ sender: Any) {
        let count  = Int(lblquantity.text!)
        if count! > 1 {
            lblquantity.text = String((count ?? 1) - 1)
            
            let price = Float(dealItemList!.price!)! * Float(count! - 1)
            let tax = Float(schoolTax) ?? 0.0 * Float(count! - 1)
            if schoolTax != "0" {
                lblPrice.text = String(format: "%.02f", price) + " + " + "\(tax)"
            } else {
                lblPrice.text = String(format: "%.02f", price)
            }
        }
    }
    
    @IBAction func orderNow(_ sender: Any) {
        if DataManager.sharedInstance.getPermanentlySavedUser()!.stripe_customer_id != "" {
         oderNow()
        } else {
            let storyboard = UIStoryboard(name: "AddCard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddCard")
            
            self.present(vc, animated: true)
        }
    }
   
    func oderNow() {
        
        if self.chooseDate.count == 0 {
            self.ShowErrorAlert(message: "Choose date", AlertTitle: "")
            return
        }
        
//        if self.tfPhoneNumber.text?.count != 10 {
//            self.ShowErrorAlert(message: "Enter phone number ", AlertTitle: "")
//            return
//        }
//
        self.showLoading()
        var param = [String : AnyObject]()
        let priceArray = lblPrice.text?.split(separator: "+")
        param["school_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        param["user_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.id as AnyObject
        param["amount"] =  priceArray?[0].trimmingCharacters(in: .whitespaces) as AnyObject
//        param["department_id"] = lblPrice.text! as AnyObject
        param["deal_data[]"] = "[" + "\(dealItemList!.id!)" + "]" as AnyObject
        param["deal_quantity[]"] = "[" + "\(lblquantity.text!)" + "]" as AnyObject
        param["order_date"] = self.chooseDate as AnyObject
//        param["phone_number"] = self.tfPhoneNumber.text as AnyObject
        param["amount_charge"] =  "1" as AnyObject
        if priceArray?[1] != nil {
            param["amount_charge"] =  priceArray?[1].trimmingCharacters(in: .whitespaces) as AnyObject
        }
        if DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes" || DataManager.sharedInstance.user?.is_concession_person.lowercased() == "yes"  {
            param["orgnizer_name"] = DataManager.sharedInstance.user?.user_name as AnyObject
        }
        print("Params-->> 333",param)
        
        NetworkManager.PostAPI(jsonParam: param, WebServiceName: APIName.lunchDealOrder) { (pStatus, pMsg, pData) in
            self.hideLoading()
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    self.hideLoading()
                    self.ShowErrorAlert(message: dataMain["message"] as! String , AlertTitle: "")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.hideLoading()
                    if let dataMessage = dataMain["message"] as? String {
                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
                    } else {
                        self.ShowErrorAlert(message: "Something wrong" , AlertTitle: "")
                        
                    }
                }
            }
            
        }
        
    }
    
}

extension LunchDealDetailVC: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("height: ",self.collectionView.frame.size.height )
        return CGSize.init(width: self.view.frame.size.width, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dealItemList?.deals?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LunchItemCell", for: indexPath) as! LunchItemCell
        cell.nameLbl.text = String(dealItemList?.deals?[indexPath.row].quantity ?? 1) + " " + (dealItemList?.deals?[indexPath.row].name ?? "")
//        cell.quantityLbl.text = "Qantity: " + "1"
        let strMain = (kBaseItemImageURL + dealItemList!.deals![indexPath.row].image!)
        self.downloadImage(imgview: cell.imageItem, URL: strMain)
        return cell
    }
    
}

extension LunchDealDetailVC :UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 100 {
            
            let datePicker = DatePickerDialog.init()
            
            let dateStart = Date().startOfWeek().dateByAddingDays(8)
            datePicker.show("Choose Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: dateStart, minimumDate: dateStart, maximumDate: dateStart.dateByAddingDays(6), datePickerMode: .date, timeInterval: 0) { (datChoose) in
                self.tfCalendar.text = datChoose?.dateString("yyyy-MM-dd")
                self.chooseDate = self.tfCalendar.text!
            }
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == -100 {
            if string.count > 0 {
                if textField.text!.count < 10 {
                    return true
                }else {
                    return false
                }
            }
        }
        
        return true
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    func dateByAddingDays(_ dDays: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.day = dDays
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}
