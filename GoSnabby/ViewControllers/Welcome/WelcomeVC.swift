//
//  ViewController.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 29/01/2021.
//

import UIKit
import Foundation

class WelcomeVC: BaseVC {
    @IBOutlet var lblHeading : UILabel!
    @IBOutlet var lblText : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.PushViewWithStoryBoard(name: "OrderCompletedVC", StoryBoard: "OrderCompleted")
        if DataManager.sharedInstance.user?.id != "" {
            let viewTab = self.GetView(nameViewController:kConstantsStoryBoard.Maintabbar , nameStoryBoard: "BottomTabbar")
            viewTab.modalPresentationStyle = .fullScreen
            self.present(viewTab, animated: true) {
                
            }
        } else if DataManager.sharedInstance.getPermanentlySavedAdmin()?.id != nil && DataManager.sharedInstance.getPermanentlySavedAdmin()?.id != "" {
            let viewTab = self.GetView(nameViewController:kConstantsStoryBoard.MaintabbarForAdmin , nameStoryBoard: "BottomTabberAdmin")
            viewTab.modalPresentationStyle = .fullScreen
            self.present(viewTab, animated: true) {
                
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAPI()
    }
    
    func getAPI(){
        self.showLoading()
        NetworkManager.GetAPI(jsonParam: nil, WebServiceName: "app_screen") { (pStatus, pMSG, pData) in
            self.hideLoading()
            print("app_screen ==>")
            print(pStatus)
            
            print(pMSG)
            print(pData)
            
            if pStatus {
                if let dataMain = pData as? [String : Any] {
                    print(dataMain["data"])
                    if let dataInner = dataMain["data"] as? [String : Any] {
                        self.lblText.text = dataInner["description"] as! String
                        self.lblHeading.text = dataInner["title"] as! String 
                    }
                    
                }
                
            }
        }
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
        self.PushViewWithStoryBoard(name: "SchoolVC", StoryBoard: kConstantsStoryBoard.School)
    }
    
    @IBAction func signInAdmin(_ sender: Any) {
        navigateToSignInForAdmin()
    }
    
    func navigateToSignInForAdmin() {
        let SigninVC = self.GetView(nameViewController: "SigninVC", nameStoryBoard:kConstantsStoryBoard.Signin ) as! SigninVC
        SigninVC.isAdmin = true
        self.navigationController?.pushViewController(SigninVC, animated: true)
    }
}

