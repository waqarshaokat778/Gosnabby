//
//  ItemDetailsForAdminVC.swift
//  GoSnabby
//
//  Created by Abdullah on 3/3/21.
//

import UIKit

class ItemDetailsForAdminVC: BaseVC {

    var dealItemList: [String]?
    var isForLunch: Bool = true
    var foodsList: FoodOrderDataModel?
    var lunchList: LunchOrderDataModel?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSubname: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDealNumber: UILabel!
    @IBOutlet weak var lblquantity: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
        
    override func viewWillAppear(_ animated: Bool) {
        self.NavigationHide(status: true)
//        self.TabbarHide(status: true)
        
        pageController.numberOfPages = foodsList?.productsListings?.count ?? 0
        if isForLunch {
            pageController.numberOfPages = lunchList?.productsListings?.count ?? 0
            lblquantity.text = "Quantity: " + String(describing: lunchList!.orderData![0].quantity!)
        }
        
        setupField()
        
    }
    
    func setupField() {
        
        if isForLunch {
            lblDealNumber.text = "Order Number: " + String(describing: lunchList!.id!)
            lblName.text = lunchList?.lunchDealName
            lblPrice.text = "$ " + String(describing: lunchList!.amount!)
            lblSubname.text = lunchList?.lunchDealDetail
            lblDescription.text = lunchList?.datumDescription
            
        } else {
            
            lblquantity.text = "Quantity: " + String(describing: foodsList!.numProduct!)
            lblDealNumber.text = "Order Number: " + String(describing: foodsList!.id!)
            lblName.text = foodsList?.userName
            lblPrice.text = "$ " + String(describing: foodsList!.amount!)
            lblSubname.text = foodsList!.depName!
            lblDescription.text = foodsList!.orderDescription!
        }
        
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewAll(_ sender: Any) {
        
        let itemDetailsVC = self.GetView(nameViewController: "LunchHistoryVC", nameStoryBoard: "LunchHistory" ) as! LunchHistoryVC
        itemDetailsVC.isForAdmin = true
        if isForLunch {
            print("sending data: ", lunchList)
            itemDetailsVC.isForLunch = true
            itemDetailsVC.itemList = lunchList?.productsListings
        } else {
            itemDetailsVC.isForLunch = false
            itemDetailsVC.itemFoodList = foodsList?.productsListings
        }
        self.navigationController?.pushViewController(itemDetailsVC, animated: true)

    }
    
}

extension ItemDetailsForAdminVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isForLunch {
            return lunchList?.productsListings?.count ?? 0
        }
        return foodsList?.productsListings?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LunchItemCell", for: indexPath) as! LunchItemCell
        if isForLunch {
            if lunchList?.productsListings?[indexPath.row].productImage == nil {
                cell.imageItem.image = UIImage(named: "imagePlaceholder")
            } else {
                self.downloadImage(imgview: cell.imageItem, URL: kBaseItemImageURL + (lunchList?.productsListings?[indexPath.row].productImage ?? "") )
            }
        }
        
        return cell
    }
    
}

extension ItemDetailsForAdminVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height )
        }
    
}
