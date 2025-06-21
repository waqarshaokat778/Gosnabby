//
//  OrderHistoryVC.swift
//  GoSnabby
//
//  Created by Abdullah on 5/27/21.
//

import UIKit

class OrderHistoryVC: BaseVC {
    
    var pendingOrderList : [OrderHistoryData] = []
    var completeOrderList: [OrderHistoryData] = []
    var orderDataList: [OrderHistoryData] = []
    
    var selectedTab = 0
    
//    @IBOutlet weak var allorderBtnView: UIView!
//    @IBOutlet weak var pendingBtnView: UIView!
//    @IBOutlet weak var completeBtnView: UIView!
    @IBOutlet weak var activeTabLbl: UILabel!
    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var orderHistoryTbl: UITableView!
    @IBOutlet weak var emptyIndicator: UIImageView! {
        didSet {
            emptyIndicator.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderHistoryTbl.register(UINib.init(nibName: "FoodHistoryCell", bundle: nil), forCellReuseIdentifier: "OrderHistoryCell")
        self.orderHistoryTbl.delegate = self
        self.orderHistoryTbl.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getOrderHistoryList()
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapTab(_ sender: UIButton) {
        selectedTab = sender.tag
        switch selectedTab {
        case 0:
            activeTabLbl.text = "All Orders"
        case 1:
            activeTabLbl.text = "Pending Orders"
        default:
            activeTabLbl.text = "Completed Orders"
        }
        orderHistoryTbl.reloadData()
    }
    
    func getOrderHistoryList() {
        
        self.showLoading()
        var param = [String : AnyObject]()
        param["user_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.id as AnyObject
        param["school_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.school_id as AnyObject
        print("Params-->> 444")
        
        
        NetworkManager.PostAPI(jsonParam: param, WebServiceName: APIName.orderHistory) { (pStatus, pMsg, pData) in
            self.completeOrderList = []
            self.pendingOrderList = []
            if let dataMain = pData as? [String : Any] {
                
                let statusCode = self.CheckNullValue(value: dataMain["status"] as AnyObject)
                if statusCode == "200" {
                    self.hideLoading()

                        do {
                           
                            let json = try JSONSerialization.data(withJSONObject: dataMain)
                            let resultModel = try JSONDecoder().decode(OrderHistoryModel.self, from: json)
                           
                                print(resultModel)
                            let _ = resultModel.data?.forEach({ order in
                                print(order.status)
                                if order.status?.lowercased() == "completed" {
                                    self.completeOrderList.append(order)
                                } else {
                                    self.pendingOrderList.append(order)
                                }
                            })
                            DispatchQueue.main.async {
                                self.orderDataList = resultModel.data ?? []
                                self.orderHistoryTbl.reloadData()
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
    
    
    func markOrderComplete(orderID: Int) {
        
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

                    self.getOrderHistoryList()
                    self.orderHistoryTbl.reloadData()
                }else {
                    self.hideLoading()
                }
                
                
            }
            
        }
        
    }
}

extension OrderHistoryVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 0 {
        setupEmptyIndicator(isShow: orderDataList.count == 0)
        return orderDataList.count
        } else if selectedTab == 1 {
        setupEmptyIndicator(isShow: pendingOrderList.count == 0)
        return pendingOrderList.count
        } else {
            setupEmptyIndicator(isShow: completeOrderList.count == 0)
            return completeOrderList.count
            
        }
    }
    
    func setupEmptyIndicator(isShow: Bool) {
        if isShow {
            emptyIndicator.isHidden = false
        } else {
            emptyIndicator.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return returnOrderHistoryCell(indexPath: indexPath)
    }

    func returnOrderHistoryCell(indexPath: IndexPath) -> OrderHistoryCell {
        
        let orderHistoryCell = orderHistoryTbl.dequeueReusableCell(withIdentifier: "OrderHistoryCell", for: indexPath) as! OrderHistoryCell
        var filtered = orderDataList[indexPath.row]
        
        if selectedTab == 1 {
            filtered = pendingOrderList[indexPath.row]
        } else if selectedTab == 2 {
            filtered = completeOrderList[indexPath.row]
        }
        
        
        orderHistoryCell.orderId.text = "Order #" + String((filtered.id)!)
        orderHistoryCell.lblQty.text = "Quantity " + String(Int((filtered.totalProduct)!))
                                                            
        orderHistoryCell.lblDetails.text = filtered.depName
        orderHistoryCell.lblPrice.text = "$" + String(String(format: "%.02f", (filtered.amount)!))
        orderHistoryCell.lblOrderDate.text = filtered.createdAt?.dateString(inputformat: "yyyy-MM-dd HH:mm:ss", outputformat: "MM-dd-yyyy")

        orderHistoryCell.lblStatus.text = filtered.status?.capitalized
        orderHistoryCell.devlivedView.isHidden = true
        orderHistoryCell.statusView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        if filtered.status?.lowercased() == "received"{
            orderHistoryCell.lblStatus.text = "Pending"
            orderHistoryCell.devlivedView.isHidden = false
            orderHistoryCell.statusView.backgroundColor = #colorLiteral(red: 0.9644675851, green: 0.5987293124, blue: 0.05301333964, alpha: 1)
            orderHistoryCell.devlivedView.backgroundColor = #colorLiteral(red: 0.9644675851, green: 0.5987293124, blue: 0.05301333964, alpha: 1)
        }
        orderHistoryCell.selectionStyle = .none
        
        orderHistoryCell.devlivedView.isUserInteractionEnabled = true
        orderHistoryCell.devlivedView.tag = indexPath.row
        orderHistoryCell.devlivedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deliverdItems)))


        //For shadow
//        orderHistoryCell.viewForBackground.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.536333476), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 0, scale: false)
        orderHistoryCell.viewForBackground.borderWidth = 0.5
        orderHistoryCell.viewForBackground.borderColor = .lightGray
        orderHistoryCell.viewForBackground.cornerRadius = 8
        return orderHistoryCell
    }
    
    @objc func deliverdItems(_ tap : UITapGestureRecognizer){
        var orderid = 0
        
        if selectedTab == 0 {
            orderid = orderDataList[tap.view!.tag].id!
        } else if selectedTab == 1 {
            orderid = pendingOrderList[tap.view!.tag].id!
        } else {
            orderid = completeOrderList[tap.view!.tag].id!
            
        }
        markOrderComplete(orderID: orderid)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "OrderItemList", bundle: nil)
        let allitems = (storyboard.instantiateViewController(withIdentifier: "OrderItemList")) as! OrderItemList
        allitems.orderDataList = orderDataList[indexPath.row].productsListings
        self.navigationController?.pushViewController(allitems, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(220)
    }
}
