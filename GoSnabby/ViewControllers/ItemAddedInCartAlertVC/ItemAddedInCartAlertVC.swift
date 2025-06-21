//
//  ItemAddedInCartAlertVC.swift
//  GoSnabby
//
//  Created by TecSpine on 24/09/2021.
//

import UIKit

class ItemAddedInCartAlertVC: BaseVC {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var count: UILabel!
    
    var textToShow = ""
    var itemInCard: [FoodModel]? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        headerLbl.text = textToShow
        var count = 0
        itemInCard = DataManager.sharedInstance.getItems()
        itemInCard?.forEach({ item in
            count += Int(item.quantity) ?? 0
        })
        if count != 0 {
            self.count.text = "\(count)"
        } else {
            self.count.text = "0"
        }
    }
    
    
    
    @IBAction func checkout(_ sender: Any) {
        let viewTab = self.GetView(nameViewController:kConstantsStoryBoard.Maintabbar , nameStoryBoard: "BottomTabbar") as! UITabBarController
        viewTab.modalPresentationStyle = .fullScreen
        viewTab.selectedIndex = 2
//        if let tababarController = self.window!.rootViewController as! UITabBarController? {       tababarController.selectedIndex = tabIndex     }
        self.present(viewTab, animated: true) {
            
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        Dismiss()
    }
    
}
