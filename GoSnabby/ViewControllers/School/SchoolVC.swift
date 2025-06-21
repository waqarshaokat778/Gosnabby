//
//  SchoolViewController.swift
//  GoSnabby
//
//  Created by Muhammad Umar on 02/02/2021.
//

import UIKit
import Foundation

class SchoolVC: BaseVC {
    
    @IBOutlet var tblViewSchool : UITableView!
    @IBOutlet var tfSearch : UITextField!
    
    @IBOutlet weak var searchContainerView: UIView! {
        didSet{
            searchContainerView.borderWidth = 0.3
            searchContainerView.borderColor = UIColor.gray
            
        }
    }
    @IBOutlet weak var emptyOrgImg: UIImageView!{
        didSet {
            emptyOrgImg.isHidden = true
        }
    }
    
    var arraySchool = [SchoolModel]()
    var arrayMainSchool = [SchoolModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.tblViewSchool.register(UINib.init(nibName: "schoolCell", bundle: nil), forCellReuseIdentifier: "schoolCell")
        
        getSchoolList()
//        self.NavigationHide(status: false)
//        self.AddBackButton()
    }
    
    
    @IBAction func backMainAction(sender : UIButton){
        self.Back()
    }
    func getSchoolList() {
        print("Calling...")
        self.showLoading()
        
        self.arraySchool.removeAll()
        self.arrayMainSchool.removeAll()
        NetworkManager.GetAPI(jsonParam: nil, WebServiceName: APIName.getSchool) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                        if let arrayDummy = dataMain["data"] as? [[String : Any]] {
                            for objMain in arrayDummy {
                                self.arraySchool.append(SchoolModel.init(fromDictionary:objMain))
                                self.arrayMainSchool.append(SchoolModel.init(fromDictionary:objMain))
                            }
                        }
                    print("newArray.count ===> " )
                    print(self.arraySchool.count)
                    
                    self.tblViewSchool.reloadData()
                    
                    //Remove the Alerts 
//                }else {
//                    if let dataMessage = dataMain["message"] as? String {
//                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
//                        self.hideLoading()
//                    }
                }
                self.hideLoading()
            }
        }
        

    }
    
}

extension SchoolVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.reloaddata), userInfo: nil, repeats: false)
        return true
    }
    
    @objc func reloaddata(){
//        self.arraySchool.removeAll()
        
        self.arraySchool = self.arrayMainSchool.filter{
            $0.name.range(of: self.tfSearch.text!,
                              options: .caseInsensitive,
                              range: nil,
                              locale: nil) != nil
        }
        
        if self.tfSearch.text!.count == 0 {
            self.arraySchool = self.arrayMainSchool
        }
        
        self.tblViewSchool.reloadData()
//        self.arraySchool = filter(self.arrayMainSchool) { $0.name == self.tfSearch.text }
        
        
    }
}
extension SchoolVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arraySchool.count == 0 {
            emptyOrgImg.isHidden = false
        } else {
            emptyOrgImg.isHidden = true
        }
        return self.arraySchool.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellSchool = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath) as! schoolCell
        
        cellSchool.lblItem.text = self.arraySchool[indexPath.row].name
        
        self.downloadImage(imgview: cellSchool.imgViewItem, URL: kBaseSchoolImageURL + self.arraySchool[indexPath.row].logo)

        cellSchool.selectionStyle = .none

        return cellSchool
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        UserDefaults.standard.set(["sales_tax": arraySchool[indexPath.row].sales_tax], forKey: "SchoolTax")
        
        let SigninVC = self.GetView(nameViewController: "SigninVC", nameStoryBoard:kConstantsStoryBoard.Signin ) as! SigninVC
        SigninVC.organizationName = self.arraySchool[indexPath.row].name
        SigninVC.schoolIdfromprev = self.arraySchool[indexPath.row].id
        self.navigationController?.pushViewController(SigninVC, animated: true)
        
    }
}

class schoolCell : UITableViewCell {
    @IBOutlet var imgViewItem : UIImageView!
    @IBOutlet var lblItem : UILabel!
    
}
