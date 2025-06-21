//
//  OrderListForSchoolVC.swift
//  GoSnabby
//
//  Created by Abdullah on 3/3/21.
//

import UIKit

class OrderListForSchoolVC: BaseVC {
    
    var isForLunch: Bool = true
    var foodsList: FoodOrderAdminModel?
    var lunchList: [LunchOrderDataModel]?
    
    @IBOutlet weak var imgOrganization: UIImageView!
    @IBOutlet weak var lblOrgName: UILabel!
    @IBOutlet weak var orderListTbl: UITableView!
    @IBOutlet weak var emptyIndicator: UIImageView! {
        didSet {
            emptyIndicator.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderListTbl.delegate = self
        self.orderListTbl.dataSource = self
        self.orderListTbl.register(UINib.init(nibName: "LunchOrder", bundle: nil), forCellReuseIdentifier: "LunchOrderCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.downloadImage(imgview: imgOrganization, URL: kBaseSchoolImageURL + (DataManager.sharedInstance.getPermanentlySavedAdmin()?.logo)! )
        lblOrgName.text = DataManager.sharedInstance.getPermanentlySavedAdmin()?.name
        getOrderList()
    }
    
    @IBAction func logoutAction(sender : UIButton){
        DataManager.sharedInstance.logoutUser()
        self.dismiss(animated: true) {
        }
    }
    
    func getOrderList() {
        
        self.showLoading()
        var param = [String : AnyObject]()
        param["school_id"] = DataManager.sharedInstance.getPermanentlySavedAdmin()?.id as AnyObject
        
        var webServiceName = APIName.OrderListForAdmin
        if isForLunch{
            webServiceName = APIName.LunchListForAdmin
        }
        
        print("Params-->> 222",webServiceName, param)
        NetworkManager.PostAPI(jsonParam: param, WebServiceName: webServiceName) { (pStatus, pMsg, pData) in
            
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    self.hideLoading()

                        do {
                            let json = try JSONSerialization.data(withJSONObject: dataMain)
                            if self.isForLunch {
                               
                                let resultModel = try JSONDecoder().decode(LunchOrderAdminModel.self, from: json)
                                print(resultModel)
                                DispatchQueue.main.async {
                                   let filterData =  resultModel.data?.filter({ (item) -> Bool in
                                        return item.lunchDealName != nil && item.lunchDealImage != nil
                                    })
                                    print("Filter Data", filterData as Any)
                                    self.lunchList = filterData
                                    self.orderListTbl.reloadData()
                                }

                            } else {
                                
                                let resultModel = try JSONDecoder().decode(FoodOrderAdminModel.self, from: json)
                                print(resultModel)
                                DispatchQueue.main.async {
                                    self.foodsList = resultModel
                                    self.orderListTbl.reloadData()
                                }

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
//                    }
                }
                
            } else {
                print("error in converting  dictionary")
            }
        }
        
    }
    
}

extension OrderListForSchoolVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isForLunch {
            if lunchList?.count == 0 {
                emptyIndicator.isHidden = false
            } else {
                emptyIndicator.isHidden = true
            }
            return lunchList?.count ?? 0
        }
        if foodsList?.data?.count == 0 {
            emptyIndicator.isHidden = false
        } else {
            emptyIndicator.isHidden = true
        }
        return foodsList?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LunchOrderCell", for: indexPath) as! LunchOrderCell
        cell.statusContainer.isHidden = true
        
        if isForLunch  {
            
            let filter = lunchList?[indexPath.row]
            cell.lblorderNo.text = String(describing: filter!.id!)
            cell.lblCustomerName.text = filter!.userName
            cell.lblTransID.text = String(describing: filter!.transactionID ?? "")
            cell.lblPaymentType.text = filter!.paymentType
            cell.lblOrderDate.text = filter!.createdAt!.formatTheDate()
            cell.lblReceivingDate.text = filter!.orderDate!.formatTheDate()
            cell.lblPrice.text = "$" + String(format: "%.02f", filter!.amount ?? 0)
            cell.lblActionTitle.text = "Detail"
            
        } else {
            
            let filter = foodsList?.data?[indexPath.row]
            cell.statusContainer.isHidden = false
            cell.lblorderNo.text = String(describing: filter!.id!)
            cell.lblCustomerName.text = filter!.userName ?? ""
            
            cell.transIdLbl.text = "Department: "
            cell.lblTransID.text = filter!.depName
            
            cell.paymentTypeLbl.text = "Food:"
            cell.lblPaymentType.text = filter!.productData
            
            cell.orderDateLbl.text = "Payment Type:"
            cell.lblOrderDate.text = filter!.paymentType
            
            cell.receivingDataLbl.text = "Order Date:"
            cell.lblReceivingDate.text = filter!.createdAt?.formatTheDate()
            cell.lblPrice.text = "$" + String(format: "%.02f", filter!.amount!)
            cell.lblActionTitle.text = "View"
            
            cell.lblStatus.text = filter!.status
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isForLunch {
            let itemDetailsVC = self.GetView(nameViewController: "LunchHistoryVC", nameStoryBoard: "LunchHistory" ) as! LunchHistoryVC
            itemDetailsVC.isForAdmin = true
            if isForLunch {
                itemDetailsVC.isForLunch = true
                itemDetailsVC.itemList = lunchList?[indexPath.row].productsListings
            } else {
                itemDetailsVC.isForLunch = false
                itemDetailsVC.itemFoodList = foodsList?.data?[indexPath.row].productsListings
            }
            self.navigationController?.pushViewController(itemDetailsVC, animated: true)
        } else {
            let mainSB = UIStoryboard(name: "ItemDetailsForAdmin", bundle: nil)
            let detailVC = mainSB.instantiateViewController(withIdentifier: "ItemDetailsForAdminVC") as! ItemDetailsForAdminVC
            detailVC.isForLunch = self.isForLunch
            detailVC.foodsList = foodsList?.data?[indexPath.row]
            detailVC.lunchList = lunchList?[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
        if isForLunch {
            return 236
        }
        return 276
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
