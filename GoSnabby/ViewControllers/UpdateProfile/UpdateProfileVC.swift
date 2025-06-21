//
//  UpdateProfileVC.swift
//  GoSnabby
//
//  Created by Abdullah on 5/27/21.
//

import UIKit

class UpdateProfileVC: BaseVC, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    
    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var editImage: UIView!
    
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    var imagePicker = UIImagePickerController()
    var isImageChange = false
    var isPasswordChange = false
    var selectedImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editProfileTap = UITapGestureRecognizer.init(target: self, action: #selector(editProfile))
        editImage.isUserInteractionEnabled = true
        editImage.addGestureRecognizer(editProfileTap)
        self.tfPhoneNumber.delegate = self
        self.tfPhoneNumber.tag = -100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpField()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func updateProfileAction(_ sender: Any) {
        updateProfile()
    }
    
    func setUpField(){
        contentHeight.constant = 650
        if UIScreen.main.bounds.height > 750.0 {
            contentHeight.constant = UIScreen.main.bounds.height - 180
        }
        tfName.text = DataManager.sharedInstance.user?.user_name
        tfPhoneNumber.text = DataManager.sharedInstance.user?.phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        let newURL = kBaseUserImageURL + DataManager.sharedInstance.user!.profile_image
        self.downloadImage(imgview: self.profileImg, URL: newURL)
    }
    
    @objc func editProfile(_ tap : UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            isImageChange = true
            selectedImage = image
            profileImg.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateProfile() {
        
        if self.tfName.text!.count == 0 {
            self.ShowErrorAlert(message: "Enter your Name.", AlertTitle: "")
            return
        }else if self.tfPhoneNumber.text!.count == 0 {
            self.ShowErrorAlert(message: "Enter your Phone Number.", AlertTitle: "")
            return
        } else{
            if tfOldPassword.text!.count != 0 {
                if tfOldPassword.text! != DataManager.sharedInstance.user?.password {
                    self.ShowErrorAlert(message: "Password is wrong.", AlertTitle: "")
                    return
                } else if self.tfNewPassword.text!.count == 0 && self.tfConfirmPassword.text!.count == 0 {
                    self.ShowErrorAlert(message: "Please fill all fields.", AlertTitle: "")
                    return
                } else if self.tfNewPassword.text! != self.tfConfirmPassword.text! {
                    self.ShowErrorAlert(message: "Password not matched.", AlertTitle: "")
                    return
                } else {
                    self.isPasswordChange = true
                }
            }
        
            var newPAram = [String : AnyObject]()
            newPAram["user_id"] = DataManager.sharedInstance.user!.id as AnyObject
            newPAram["school_id"] = DataManager.sharedInstance.user!.school_id as AnyObject
            newPAram["user_name"] = tfName.text! as AnyObject
            newPAram["phone"] = tfPhoneNumber.text! as AnyObject
            newPAram["email"] = DataManager.sharedInstance.user!.email as AnyObject
            if isPasswordChange {
                newPAram["password"] = tfNewPassword.text! as AnyObject
            }
            
    
            print("<==== newPAram ===>")
            print(newPAram)
            self.showLoading()
            
            NetworkManager.PostUserImageAPI(jsonParam: newPAram, WebServiceName: "update_profile", imageMain: selectedImage) { (pStatus, pMsg, pData) in
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
                            self.ShowSuccessAlert(message: dataMain["message"] as! String , AlertTitle: "")
                            self.tfOldPassword.text = ""
                            self.tfNewPassword.text = ""
                            self.tfConfirmPassword.text = ""
                            NotificationCenter.default.post(name: updateProfileNoti , object: self, userInfo: nil)
    
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

extension UpdateProfileVC : UITextFieldDelegate {
     
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

