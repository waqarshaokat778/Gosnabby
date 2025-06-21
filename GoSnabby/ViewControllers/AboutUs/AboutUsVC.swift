//
//  AboutUsVC.swift
//  GoSnabby
//
//  Created by Abdullah on 2/20/21.
//

import UIKit

class AboutUsVC: BaseVC {

    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var contents: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.NavigationHide(status: true)
        self.TabbarHide(status: true)
        self.contents.text = ""
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
                        self.contents.text  = dataInner["about"] as! String
                        self.contents.dataDetectorTypes = UIDataDetectorTypes.all

                    }
                    
                }
                
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
