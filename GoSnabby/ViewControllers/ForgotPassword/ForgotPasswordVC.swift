//
//  ForgotPasswordVC.swift
//  GoSnabby
//
//  Created by Abdullah on 5/10/21.
//

import UIKit

class ForgotPasswordVC: BaseVC {

    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        setNewPasswordAccount()
    }
    
    func setNewPasswordAccount(){
        
        let email: String? = self.tfEmail.text as String?
        if self.tfEmail.text!.count == 0 {
            self.ShowErrorAlert(message: "Enter your email", AlertTitle: "")
            return
        }else if email!.isValidEmail == false {
            self.ShowErrorAlert(message: "Enter valid email", AlertTitle: "")
            return
        }else{
            
            self.showLoading()
            var param = [String : AnyObject]()
            param["email"] = email as AnyObject
           
            let servicename = APIName.setNewPassword
            NetworkManager.PostAPI(jsonParam: param, WebServiceName: servicename) { (pStatus, pMsg, pData) in
                if let dataMain = pData as? [String : Any] {
                    
                    let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                    if statusCode == "200" {
                        self.hideLoading()
                        
                        if let dataMessage = dataMain["message"] as? String {
                            self.navigateToLogin()
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
    
    func navigateToLogin() {
        let alert = UIAlertController(title: "" , message: "An email has been sent to your email address, please check the mail and change your password.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        })
       
        self.present(alert, animated: true, completion: nil)
    }
    
}
