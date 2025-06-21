//
//  AlertForInfoVC.swift
//  GoSnabby
//
//  Created by TecSpine on 18/09/2021.
//

import UIKit

class AlertForInfoVC: BaseVC {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerLbl: UILabel!
    var hideName = true
//    var hidePhone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfPhoneNumber.delegate = self
        self.tfPhoneNumber.tag = -100
        setUpView()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if hideName {
            headerLbl.text = "Add/Update Phone Number"
        } else {
            headerLbl.text = "Concession Faculty/Admin"
        }
        setUpFields()
        UserDefaults.standard.set(true, forKey: "isVisited")
    }
    
    func setUpFields(){
        tfName.text = DataManager.sharedInstance.user!.user_name
        tfPhoneNumber.text = DataManager.sharedInstance.user!.phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
    }
    
    
    func setUpView() {
        nameContainerView.isHidden = hideName
        heightConstraint.constant = 180
        if !hideName {
            heightConstraint.constant = 234
        }
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        updateProfile()
    }
    @IBAction func dismiss(_ sender: Any) {
        Dismiss()
    }
    
    func updateProfile() {
        
        if self.tfName.text!.count == 0 {
            self.ShowErrorAlert(message: "Enter your Name.", AlertTitle: "")
            return
        }else if self.tfPhoneNumber.text!.count == 0 {
            self.ShowErrorAlert(message: "Enter your Phone Number.", AlertTitle: "")
            return
        } else{
           
        
            var newPAram = [String : AnyObject]()
            newPAram["user_id"] = DataManager.sharedInstance.user!.id as AnyObject
            newPAram["school_id"] = DataManager.sharedInstance.user!.school_id as AnyObject
            newPAram["user_name"] = tfName.text! as AnyObject
            newPAram["phone"] = tfPhoneNumber.text! as AnyObject
           
           
            print("<==== newPAram ===>")
            print(newPAram)
            self.showLoading()
            
            NetworkManager.PostUserImageAPI(jsonParam: newPAram, WebServiceName: "update_profile", imageMain: nil) { (pStatus, pMsg, pData) in
                self.hideLoading()
    
                if let dataMain = pData as? [String : Any] {
                    let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                    if statusCode == "200" {
                        // For Object
                        if let dataObj = dataMain["data"] as? [String : AnyObject] {
                            self.hideLoading()
    
                            let userMain = SigninModel.init(json: dataObj)
                            DataManager.sharedInstance.user = userMain
                            DataManager.sharedInstance.saveUserPermanentally()
                            NotificationCenter.default.post(name: updateProfileNoti , object: self, userInfo: nil)
//                            self.ShowSuccessAlert(message: dataMain["message"] as! String , AlertTitle: "")
                            self.Dismiss()
                           
    
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
}
extension AlertForInfoVC : UITextFieldDelegate {
     func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField.tag == -100 {
            guard let text = textField.text else { return false }
            if str.count > 14{
                return false
            }
            tfPhoneNumber.text = text.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        }
        return true
    }
    
}
