//
//  LunchHistoryVC.swift
//  GoSnabby
//
//  Created by Abdullah on 2/25/21.
//

import UIKit

class LunchHistoryVC: BaseVC {
    
    var isForAdmin = false
    var lunchDataList: LunchHistoryModel?
    var itemList: [LunchOrderDataModel.ProductsListing]?

    var isForLunch: Bool = true
    var itemFoodList: [FoodOrderDataModel.ProductsListingModel]?
        
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lunchHistoryTbl: UITableView!
    @IBOutlet weak var emptyIndicator: UIImageView! {
        didSet {
            emptyIndicator.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lunchHistoryTbl.delegate = self
        self.lunchHistoryTbl.dataSource = self
        self.lunchHistoryTbl.register(UINib.init(nibName: "LunchHistoryCell", bundle: nil), forCellReuseIdentifier: "LunchHistoryCell")
        self.lunchHistoryTbl.register(UINib.init(nibName: "AllDealItemAdminCell", bundle: nil), forCellReuseIdentifier: "AllDealItemAdminCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblHeader.text = "All Items"
        if !isForAdmin {
            lblHeader.text = "Lunch History"
            getLunchHistoryList()
        }
        lunchHistoryTbl.reloadData()
        
        
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getLunchHistoryList() {
        
        self.showLoading()
        var param = [String : AnyObject]()
        param["user_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.id as AnyObject
        
        print("Params-->> 444")
        
        
        NetworkManager.PostAPI(jsonParam: param, WebServiceName: APIName.lunchHistory) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    self.hideLoading()

                        do {
                           
                            let json = try JSONSerialization.data(withJSONObject: dataMain)
                            let resultModel = try JSONDecoder().decode(LunchHistoryModel.self, from: json)
                           
                                print(resultModel)
                           
                            DispatchQueue.main.async {
                                self.lunchDataList = resultModel
                                self.lunchHistoryTbl.reloadData()
                            }

                           } catch let myJSONError {
                            print(myJSONError,myJSONError.localizedDescription)
                           }
                    
                }else {
                    self.hideLoading()
//                    if let dataMessage = dataMain["message"] as? String {
//                        self.ShowErrorAlert(message: "No Lunch History Found" , AlertTitle: "")
//                    }else{
//                        self.ShowErrorAlert(message: "Something wrong" , AlertTitle: "")
//
//                    }
                }
                
                
            }
            
        }
        
    }
}

extension LunchHistoryVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isForAdmin {
            if isForLunch {
                setupEmptyIndicator(isShow: itemList?.count == 0)
                return itemList?.count ?? 0
            }
            
            setupEmptyIndicator(isShow: itemFoodList?.count == 0)
            return itemFoodList?.count ?? 0
        }
        setupEmptyIndicator(isShow: lunchDataList?.data?.count == 0 || lunchDataList?.data == nil)
        return lunchDataList?.data?.count ?? 0
    }
    
    func setupEmptyIndicator(isShow: Bool) {
        if isShow {
            emptyIndicator.isHidden = false
        } else {
            emptyIndicator.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isForAdmin {
            return returnDealItemCellView(indexPath: indexPath)
        }
       return returnlunchHistoryCell(indexPath: indexPath)
    }
    
    func returnDealItemCellView(indexPath: IndexPath) -> AllDealItemAdminCell {
        
        let dealItemList = lunchHistoryTbl.dequeueReusableCell(withIdentifier: "AllDealItemAdminCell", for: indexPath) as! AllDealItemAdminCell
        if isForLunch {
            let filtered = itemList?[indexPath.row]
            
            dealItemList.lblName.text = filtered?.productName
            if filtered?.productImage == nil {
                dealItemList.imageViewFood.image = UIImage(named: "imagePlaceholder")
            } else {
                self.downloadImage(imgview: dealItemList.imageViewFood, URL: kBaseItemImageURL + (filtered?.productImage ?? "") )
            }
            dealItemList.lblPrice.text = "$" + (filtered?.productPrice ?? "")

            dealItemList.lblproductId.text = String(describing: filtered!.productID! )
            dealItemList.lblQuantity.text = String(describing:filtered!.productQuantity! )
        } else {
            
            let filtered = itemFoodList?[indexPath.row]
            
            dealItemList.lblName.text = filtered?.name
            if filtered?.image == nil {
                dealItemList.imageViewFood.image = UIImage(named: "imagePlaceholder")
            } else {
                self.downloadImage(imgview: dealItemList.imageViewFood, URL: kBaseItemImageURL + (filtered?.image ?? "") )
            }
            dealItemList.lblPrice.text = "$" + (filtered?.price ?? "")

            dealItemList.lblproductId.text = String(describing: filtered!.id! )
            dealItemList.lblQuantity.text = String(describing:filtered!.quantity!)
        }
        
        dealItemList.selectionStyle = .none
        //For shadow
//        dealItemList.viewForBackground.dropShadow(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), opacity: 0.16, offSet: CGSize(width: -4, height: 20), radius: 2, scale: false)
        dealItemList.viewForBackground.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dealItemList.viewForBackground.borderWidth = 0.4
        dealItemList.viewForBackground.cornerRadius = 8
        
        return dealItemList
    }
    
    
    func returnlunchHistoryCell(indexPath: IndexPath) -> LunchHistoryCell {
        
        let lunchHistoryCell = lunchHistoryTbl.dequeueReusableCell(withIdentifier: "LunchHistoryCell", for: indexPath) as! LunchHistoryCell
        let filtered = lunchDataList?.data?[indexPath.row]
        
        lunchHistoryCell.lblName.text = filtered?.lunchDealName
        lunchHistoryCell.lblQty.text = "Quantity " + (String(describing: filtered!.lunchDealQuantity!))
        lunchHistoryCell.orderIdLbl.text = "Order id " + String(filtered!.id!)
        if filtered?.lunchDealImage == nil {
            lunchHistoryCell.imageViewFood.image = UIImage(named: "imagePlaceholder")
        } else {
            self.downloadImage(imgview: lunchHistoryCell.imageViewFood, URL: kBaseLunchImageURL + (filtered?.lunchDealImage)! )
        }
        
        lunchHistoryCell.lblDetails.text = filtered?.lunchDealDetail
        lunchHistoryCell.lblPrice.text = "$" + String(filtered?.amount ?? 0)
//        lunchHistoryCell.lblOrderDate.text = filtered?.createdAt!
        lunchHistoryCell.lblOrderDate.text = filtered?.createdAt?.dateString(inputformat: "yyyy-MM-dd HH:mm:ss", outputformat: "MM-dd-yyyy")
        lunchHistoryCell.lblCompleteDate.text = filtered?.orderDate?.dateString(inputformat: "yyyy-MM-dd HH:mm:ss", outputformat: "MM-dd-yyyy")
        
        let currentDate = Date()
        let orderDeliverDate = filtered?.orderDate?.returnDateFromString()
        if  orderDeliverDate != nil {
            if currentDate < orderDeliverDate!  {
                lunchHistoryCell.statusLbl.text = "Pending"
                lunchHistoryCell.statusBgColorImg.image = UIImage(named: "OringeContainer")
            } else {
                lunchHistoryCell.statusBgColorImg.image = UIImage(named: "greenContainer")
                lunchHistoryCell.statusLbl.text = "Complete"
            }
        } else {
            lunchHistoryCell.statusLbl.text = "Error"
        }
        
        
        lunchHistoryCell.selectionStyle = .none

     
        //For shadow
//        lunchHistoryCell.viewForBackground.dropShadow(color: .lightGray, opacity: 0.3, offSet: CGSize(width: -1, height: 2), radius: 3, scale: true)
        lunchHistoryCell.viewForBackground.borderWidth = 0.4
        lunchHistoryCell.viewForBackground.borderColor = .lightGray
        lunchHistoryCell.viewForBackground.cornerRadius = 8
        return lunchHistoryCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isForAdmin {
            return CGFloat(180)
        }
        return CGFloat(264)
    }
}
