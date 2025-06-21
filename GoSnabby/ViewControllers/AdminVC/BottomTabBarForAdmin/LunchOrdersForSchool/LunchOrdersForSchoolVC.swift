//
//  LunchOrdersForSchoolVC.swift
//  GoSnabby
//
//  Created by Abdullah on 3/3/21.
//

import UIKit

class LunchOrdersForSchoolVC: BaseVC {

   
    override func viewWillAppear(_ animated: Bool) {
        self.NavigationHide(status: false)
        setUpView()
    }

    func setUpView(){
        let lunchOrderVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderListForSchoolVC") as! OrderListForSchoolVC
        lunchOrderVC.isForLunch = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        lunchOrderVC.view.frame = self.view.bounds
        self.view.addSubview(lunchOrderVC.view)
        self.addChild(lunchOrderVC)
    }
}
