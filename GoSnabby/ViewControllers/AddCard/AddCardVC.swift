//
//  AddCardVC.swift
//  GoSnabby
//
//  Created by Abdullah on 4/5/21.
//

import UIKit

class AddCardVC: BaseVC {
    
    @IBOutlet weak var cardNoField: UITextField!
    @IBOutlet weak var cvcNoField: UITextField!
    @IBOutlet weak var expireDateView: UIView!
    @IBOutlet weak var expireDateField: UITextField! {
        didSet {
//            expireDateField.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var datePickerView: UIPickerView!
    
    @IBOutlet weak var pickerContainerView: UIView!{
        didSet {
            pickerContainerView.isHidden = true
        }
    }
//    var pickerYearsList: [Int] = [Int]()
//    var pickerMonthsList: [String] = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    
//    var year = ""
//    var month = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(getExpireDate))
//        expireDateView.isUserInteractionEnabled = true
//        expireDateView.addGestureRecognizer(tap)
        expireDateField.delegate = self
//        getYear()
    
//        self.datePickerView.delegate = self
//        self.datePickerView.dataSource = self
    
    }
    
    @IBAction func hideCard(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func addCardInfo(_ sender: Any) {
        
        guard let cardNo = cardNoField.text, !cardNo.isEmpty, let cvcNo = cvcNoField.text, !cvcNo.isEmpty,  let expireNo = expireDateField.text, !expireNo.isEmpty else {
            self.ShowErrorAlert(message: "Please fill all field", AlertTitle: "")
            return
        }
        
        guard expireNo.count == 5  else {
            self.ShowErrorAlert(message: "Please enter valid expiration date ", AlertTitle: "")
            return
        }
        
        self.showLoading()
        
        
        let myStringArr = expireDateField.text?.components(separatedBy: "/")
        
        var param = [String : AnyObject]()
        param["user_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.id as AnyObject
        param["cc_number"] = cardNo as AnyObject
        param["exp_month"] = myStringArr?[0] as AnyObject
        param["exp_year"] = myStringArr?[1] as AnyObject
        param["cvc"] = cvcNo as AnyObject
        param["email"] = DataManager.sharedInstance.getPermanentlySavedUser()?.email as AnyObject
        print(param)
        
        NetworkManager.PostAPI(jsonParam: param, WebServiceName: APIName.addCard) { (pStatus, pMsg, pData) in
            
            self.hideLoading()
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    self.hideLoading()
                    
                    DispatchQueue.main.async {
                        if let dataObj = dataMain["data"] as? [String : AnyObject]  {
                            let userMain =
                                SigninModel.init(json: dataObj)
                            DataManager.sharedInstance.user = userMain
                            DataManager.sharedInstance.saveUserPermanentally()
                            
                            let alertController = UIAlertController(title: "", message: dataMain["message"] as? String, preferredStyle: .alert)

                                // Create the actions
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                                self.dismiss(animated: true)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                    }
                    
                   
                    
                } else {
                    self.hideLoading()
                    if let dataMessage = dataMain["message"] as? String {
                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
                    } else {
                        self.ShowErrorAlert(message: "Something wrong" , AlertTitle: "")
                        
                    }
                }
            } else {
                self.ShowErrorAlert(message: "Please check Details" , AlertTitle: "")
            }
            
        }
    }
    
    @IBAction func getExpirDate(_ sender: Any) {
//        UIView.animate(withDuration: 5) {
//            self.pickerContainerView.isHidden = true
//        }
//        month = pickerMonthsList[ datePickerView.selectedRow(inComponent: 0)]
//        year = "\(pickerYearsList[datePickerView.selectedRow(inComponent: 1)])"
//        expireDateField.text = pickerMonthsList[ datePickerView.selectedRow(inComponent: 0)] + "/" + "\(pickerYearsList[datePickerView.selectedRow(inComponent: 1)])"
    }
    
//    func getYear() {
//        var year = Calendar.current.component(.year, from: Date())
//        year = year % 100
//
//
//        for index in 0...9 {
//            self.pickerYearsList.append(year + index)
//        }
//    }
   
    @objc func getExpireDate(_ tap: UITapGestureRecognizer) {
            UIView.animate(withDuration: 5) {
                self.pickerContainerView.isHidden = false
            }
    }
    
}

//extension AddCardVC: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 1 {
//          return pickerYearsList.count
//        }
//        return pickerMonthsList.count
//    }
//
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0 {
//            return pickerMonthsList[row]
//        }
//        return "\(pickerYearsList[row])"
//    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//    }
    
    
//}

extension AddCardVC : UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField.tag == -100 {
            guard let text = textField.text else { return false }
            if str.count > 5{
                return false
            }
            expireDateField.text = text.applyPatternOnNumbers(pattern: "##/##", replacementCharacter: "#")
//            return checkExpiriDateFormat(string: string, str: str)
        }
        return true
    }
    
    
    func checkExpiriDateFormat(string: String?, str: String?) -> Bool{

        
        if str!.count == 3{
           expireDateField.text = expireDateField.text! + "/"
       }else if str!.count > 5{
           return false
       }
       return true
    }
}
