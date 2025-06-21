//
//  OrderCompletedVC.swift
//  GoSnabby
//
//  Created by Abdullah on 2/20/21.
//

import UIKit

class OrderCompletedVC: BaseVC {

    @IBOutlet weak var orderPlacesLbl: UILabel!
    
    var orderID: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.NavigationHide(status: true)
        self.TabbarHide(status: true)
        let range = (orderPlacesLbl.text! as NSString).range(of: "Thanks!")

        let mutableAttributedString = NSMutableAttributedString.init(string: orderPlacesLbl.text!)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.6649263501, green: 0.2532883584, blue: 0.5774737, alpha: 1), range: range)
        orderPlacesLbl.attributedText = mutableAttributedString
    }
    
    @IBAction func navigateAction(_ sender: Any) {
        let viewTab = self.GetView(nameViewController:kConstantsStoryBoard.Maintabbar , nameStoryBoard: "BottomTabbar")
        viewTab.modalPresentationStyle = .fullScreen

        self.PushViewWithStoryBoard(name: kConstantsStoryBoard.Maintabbar, StoryBoard: "BottomTabbar")
    }
    
    @IBAction func deliveredOrder(_ sender: Any) {
        markOrderComplete()
    }
    
    func markOrderComplete() {
        
        self.showLoading()
        var param = [String : AnyObject]()
        param["id"] = orderID as AnyObject
        param["status"] = "completed" as AnyObject
        print("Params-->> 444")
        
        
        NetworkManager.PostAPI(jsonParam: param, WebServiceName: APIName.markOrderComplete) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "success" {
                    self.hideLoading()

                    DispatchQueue.main.async {
                        let viewTab = self.GetView(nameViewController:kConstantsStoryBoard.Maintabbar , nameStoryBoard: "BottomTabbar")
                        viewTab.modalPresentationStyle = .fullScreen

                        self.PushViewWithStoryBoard(name: kConstantsStoryBoard.Maintabbar, StoryBoard: "BottomTabbar")
                    }
                    
                }else {
                    self.hideLoading()
                }
                
                
            }
            
        }
        
    }
}
