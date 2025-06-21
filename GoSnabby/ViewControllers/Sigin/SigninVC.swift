//
//  SigninVC.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 04/02/2021.
//

import Foundation
import UIKit

class SigninVC: BaseVC {
    
    var schoolIdfromprev : String!
    var isSecureField: Bool = true
    var isAdmin: Bool = false
    var organizationName = ""
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var imgSecureField: UIImageView!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var forgotPassLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(setScureField))
        imgSecureField.isUserInteractionEnabled = true
        imgSecureField.addGestureRecognizer(tapGesture)
        
        
        let forgotPassTap = UITapGestureRecognizer.init(target: self, action: #selector(forgotPassword))
        forgotPassLbl.isUserInteractionEnabled = true
        forgotPassLbl.addGestureRecognizer(forgotPassTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tfEmail.text = ""
        self.tfPassword.text = ""
        let detailString = "Your selected establishment is \"" + organizationName + "\" Complete the fields below to login to your account"
        self.detailLbl.attributedText = attributedText(withString: detailString, boldString: organizationName , font: UIFont.systemFont(ofSize: 14))
        if isAdmin {
            self.detailLbl.isHidden = true
        }
    }
    
    @objc func setScureField(_ tap: UITapGestureRecognizer ) {
        if isSecureField {
            imgSecureField.image = UIImage(named: "password_see_icon")
        } else   {
            imgSecureField.image = UIImage(named: " eye-no")
        }
        isSecureField = !isSecureField
        tfPassword.isSecureTextEntry = isSecureField
        
    }
    
    @objc func forgotPassword(_ tap: UITapGestureRecognizer ) {
        self.PushViewWithStoryBoard(name: "ForgotPasswordVC", StoryBoard: kConstantsStoryBoard.forgotPassword)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func signinAction(_ sender: Any) {
       checkLoginAccount()
    }
    
    func checkLoginAccount(){
        
        let email: String? = self.tfEmail.text as String?
        if self.tfEmail.text!.count == 0 {
            self.ShowErrorAlert(message: "Enter your email", AlertTitle: "")
            return
        }else if email!.isValidEmail == false {
            self.ShowErrorAlert(message: "Enter valid email", AlertTitle: "")
            return
        }else if self.tfPassword.text!.count == 0 {
            self.ShowErrorAlert(message: "Enter Password", AlertTitle: "")
            return
        }else{
            
            self.showLoading()
            var param = [String : AnyObject]()
            param["email"] = self.tfEmail.text! as AnyObject
            param["password"] = self.tfPassword.text! as AnyObject
            
            var servicename = APIName.checkAdmin
            if !isAdmin {
                param["school_id"] = schoolIdfromprev as AnyObject
                servicename = APIName.checkUser
            }
            
            NetworkManager.PostAPI(jsonParam: param, WebServiceName: servicename) { (pStatus, pMsg, pData) in
                if let dataMain = pData as? [String : Any] {
                    
                    let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                    if statusCode == "200" {
                        
                        // For Object
                        
                        if let dataObj = dataMain["data"] as? [String : AnyObject] {
                            
                            self.hideLoading()
                            if self.isAdmin {
                                
                                let userMain =
                                    SigninModelForAdmin.init(json: dataObj)
                                DataManager.sharedInstance.admin = userMain
                                DataManager.sharedInstance.saveAdminPermanentally()
//                                self.PushViewWithStoryBoard(name: kConstantsStoryBoard.MaintabbarForAdmin, StoryBoard: "BottomTabberAdmin")
                                self.showMainAdminTab()
                            } else {
                                let userMain = SigninModel.init(json: dataObj)
                                DataManager.sharedInstance.user = userMain
                                DataManager.sharedInstance.saveUserPermanentally()
//                                self.PushViewWithStoryBoard(name: kConstantsStoryBoard.Maintabbar, StoryBoard: "BottomTabbar")
                                
                                self.showMainTab()
                            }
                            
                            
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
    
    func showMainTab(){
        let viewTab = self.GetView(nameViewController:kConstantsStoryBoard.Maintabbar , nameStoryBoard: "BottomTabbar")
        viewTab.modalPresentationStyle = .fullScreen
        self.present(viewTab, animated: true) {
            
        }
    }
    
    func showMainAdminTab(){
        let viewTab = self.GetView(nameViewController:kConstantsStoryBoard.MaintabbarForAdmin , nameStoryBoard: "BottomTabberAdmin")
        viewTab.modalPresentationStyle = .fullScreen
        self.present(viewTab, animated: true) {
            
        }
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}
