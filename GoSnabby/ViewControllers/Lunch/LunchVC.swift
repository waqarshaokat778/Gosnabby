//
//  LunchVC.swift
//  GoSnabby
//
//  Created by Abdullah on 2/25/21.
//

import UIKit

class LunchVC: BaseVC {
    
    var lunchDataList: LunchModal?
    @IBOutlet weak var lunchTableView: UITableView!
    @IBOutlet weak var emptyLunchIndicator: UIImageView! {
        didSet {
            emptyLunchIndicator.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lunchTableView.delegate = self
        self.lunchTableView.dataSource = self
        self.lunchTableView.register(UINib.init(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "FoodCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.TabbarHide(status: false)
        self.navigationClear()
        self.NavigationHide(status: true)
        getLunchList()
    }
    
    @IBAction func historyAction(_ sender: Any) {
        let foodItemDetailsVC = self.GetView(nameViewController: "LunchHistoryVC", nameStoryBoard: "LunchHistory" ) as! LunchHistoryVC
        self.navigationController?.pushViewController(foodItemDetailsVC, animated: true)
    }
    
    func getLunchList() {
        
        self.showLoading()
        var param = [String : AnyObject]()
        param["school_id"] =  DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        
        print("Params-->> 555")
        
        
        NetworkManager.PostAPI(jsonParam: param, WebServiceName: APIName.lunchDeals) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    self.hideLoading()

                       do {
                            let json = try JSONSerialization.data(withJSONObject: dataMain)
                            let resultModel = try JSONDecoder().decode(LunchModal.self, from: json)
                           
                            DispatchQueue.main.async {
                                self.lunchDataList = resultModel
                                self.lunchTableView.reloadData()
                            }

                       } catch let myJSONError {
                           print(myJSONError)
                       }
                    
                }else {
                    self.hideLoading()
//                    if let dataMessage = dataMain["message"] as? String {
//                        self.ShowErrorAlert(message: dataMessage , AlertTitle: "")
//                    }else{
//                        self.ShowErrorAlert(message: "Something wrong" , AlertTitle: "")
//
//                    }
                }
            }
            
        }
        
    }
    
}

extension LunchVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lunchDataList?.data?.count == 0 || lunchDataList?.data == nil {
            emptyLunchIndicator.isHidden = false
        } else {
            emptyLunchIndicator.isHidden = true
        }
        return lunchDataList?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let foodCell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        let filtered = lunchDataList?.data?[indexPath.row]
        
        foodCell.lblName.text = filtered?.name
        foodCell.lblDetails.text = filtered?.detail
        foodCell.lblPrice.text = "$" + String(filtered?.price ?? "0")
        foodCell.addToCartLbl.text = "Order Now" 
        if filtered?.dealImage != nil {
            self.downloadImage(imgview: foodCell.imageViewFood, URL: kBaseLunchImageURL + (filtered?.dealImage)! )
            print(kBaseItemImageURL + (filtered?.dealImage)!)
        } else {
            foodCell.imageViewFood.image = UIImage(named: "imagePlaceholder")
        }
        foodCell.buttonAddtoCart.isUserInteractionEnabled = false
        foodCell.selectionStyle = .none

        //For shadow
//        foodCell.viewForBackground.dropShadow(color: .lightGray, opacity: 0.3, offSet: CGSize(width: -1, height: 2), radius: 3, scale: true)
        foodCell.viewForBackground.borderWidth = 0.4
        foodCell.viewForBackground.borderColor = .lightGray
        foodCell.viewForBackground.cornerRadius = 6
        

        return foodCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoDealDetail(index: indexPath)
    }
   
    func gotoDealDetail(index: IndexPath) {
        
        let itemDetailsVC = self.GetView(nameViewController: "LunchDealDetailVC", nameStoryBoard:kConstantsStoryBoard.LunchDealsDetail ) as! LunchDealDetailVC
        itemDetailsVC.dealItemList = lunchDataList?.data?[index.row]
        self.navigationController?.pushViewController(itemDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
