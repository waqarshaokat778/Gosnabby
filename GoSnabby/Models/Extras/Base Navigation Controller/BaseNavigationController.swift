//
//  BaseNavigationController.swift
//  
//
//  Created by  on 07/06/2017.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
	
    var itemInCard: [FoodModel]? = nil
	/****************************************************************************************************************/
	// MARK: - Override Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = kConstantsColors.kNavigationcolor
        navigationBar.tintColor = kConstantsColors.kNavigationcolor

        
//        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.isTranslucent = true
//        self.view.backgroundColor = .clear
        
		delegate = self;
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile(_:)), name: updateProfileNoti, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCart(_:)), name: updateCartNoti, object: nil)
        
        showBadgeForAccount()
        showBadgeCountForCart()
        
	}
    
    @objc func updateProfile(_ notification: Notification) {
        showBadgeForAccount()
    }
    
    @objc func updateCart(_ notification: Notification) {
        showBadgeCountForCart()
    }
    
    
    func showBadgeForAccount() {
        if DataManager.sharedInstance.user?.phone == "" {
            if let tabItems = tabBarController?.tabBar.items {
                let tabItem = tabItems[4]
                tabItem.badgeValue = "!"
            }
        } else {
            if let tabItems = tabBarController?.tabBar.items {
                let tabItem = tabItems[4]
                tabItem.badgeValue = nil
            }
        }
    }
    
    func showBadgeCountForCart() {
        var count = 0
        itemInCard = DataManager.sharedInstance.getItems()
        itemInCard?.forEach({ item in
            count += Int(item.quantity) ?? 0
        })
        if count != 0 {
            if let tabItems = tabBarController?.tabBar.items {
                let tabItem = tabItems[2]
                tabItem.badgeValue = "\(count)"
                tabItem.badgeColor = #colorLiteral(red: 0.5643436909, green: 0.3305417299, blue: 0.6583008766, alpha: 1)
            }
        } else {
            if let tabItems = tabBarController?.tabBar.items {
                let tabItem = tabItems[2]
                tabItem.badgeValue = nil
            }
        }
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	/****************************************************************************************************************/
	// MARK: - Class Methods
	
    func AddTitle(_ target: UIViewController, title : String , color : UIColor) {
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 100, height: 30.0))
		titleLabel.text = title;
		titleLabel.textColor = color
		titleLabel.backgroundColor = UIColor.clear
		titleLabel.textAlignment = .center
//		titleLabel.font = UIFont.init(name: "SFProText-Semibold", size: (UIScreen.main.bounds.height / 568) * 15 )
        
        titleLabel.font = UIFont.systemFont(ofSize: (UIScreen.main.bounds.height / 568) * 12 )
		target.navigationItem.titleView = titleLabel
	}
    
    
 
    
    func AddImageInTitle(_ target: UIViewController){
        let logo = UIImage(named: "AppLogo")
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 35))
        imageView.image = logo
        imageView.contentMode = .scaleAspectFit
        target.navigationItem.titleView = imageView
        
    }

   
	
	func addMenuButtonOn(_ target: UIViewController, selector: Selector) {
        
        let ViewMain = UIView.init(frame: CGRect(x: 0, y: 0, width: 45.0, height: 35.0))
        ViewMain.backgroundColor = UIColor.clear
        
        
        let imgViewMain = UIImageView.init(frame: CGRect(x: 0, y: 8, width: 20.0, height: 20.0))
        imgViewMain.image = UIImage.init(named: "Menu")
        imgViewMain.contentMode = .scaleAspectFit
        imgViewMain.backgroundColor = UIColor.clear
        
        let button = UIButton.init(frame: ViewMain.frame)
        button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        
        ViewMain.addSubview(imgViewMain)
        ViewMain.addSubview(button)
        let barButtonItem = UIBarButtonItem.init(customView: ViewMain)
        target.navigationItem.setLeftBarButton(barButtonItem, animated: true)
	}
    
    func addLeftButtonOn(_ target: UIViewController, selector: Selector , image : UIImage) {
        
        let ViewMain = UIView.init(frame: CGRect(x: 0, y: 0, width: 45.0, height: 35.0))
        ViewMain.backgroundColor = UIColor.clear
        
        
        let imgViewMain = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 35.0, height: 35.0))
        imgViewMain.image = image
        imgViewMain.contentMode = .scaleAspectFit
        imgViewMain.backgroundColor = UIColor.clear
        
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 30.0, height: 30.0))
        button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        
        ViewMain.addSubview(imgViewMain)
        ViewMain.addSubview(button)
        let barButtonItem = UIBarButtonItem.init(customView: ViewMain)
        target.navigationItem.setLeftBarButton(barButtonItem, animated: true)
    }
    
    
	func addRightButton(_ target: UIViewController, selector: Selector , image : UIImage) {
        
        
        let ViewMain = UIView.init(frame: CGRect(x: 0, y: 0, width: 45.0, height: 35.0))
        ViewMain.backgroundColor = UIColor.clear
        
        
        let imgViewMain = UIImageView.init(frame: CGRect(x: 15, y: 0, width: 30.0, height: 30.0))
        imgViewMain.image = image
        imgViewMain.contentMode = .scaleAspectFit
        imgViewMain.backgroundColor = UIColor.clear
        
        
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: ViewMain.frame.size.width, height: ViewMain.frame.size.height))
        button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        
        ViewMain.addSubview(imgViewMain)
        ViewMain.addSubview(button)
        let barButtonItem = UIBarButtonItem.init(customView: ViewMain)

        target.navigationItem.setRightBarButton(barButtonItem, animated: true)
	}
    
    func RemoveRightButton(_ target: UIViewController) {
        target.navigationItem.rightBarButtonItem = nil
    }
    
    func RemoveLefttButton(_ target: UIViewController) {
        let ViewMain = UIView.init(frame: CGRect(x: 0, y: 0, width: 0.0, height: 0.0))
        ViewMain.backgroundColor = UIColor.clear
        let barButtonItem = UIBarButtonItem.init(customView: ViewMain)
        target.navigationItem.setLeftBarButton(barButtonItem, animated: true)
    }
    
	
	
	
    func addRightButtonWithTitle(_ target: UIViewController, selector: Selector , lblText : String ,widthValue : Double ) {
        
        let viewMain  = UIView.init(frame: CGRect(x: 0, y: 0, width: widthValue, height: 30.0))
        viewMain.backgroundColor = UIColor.clear
        
        let lblMain = UILabel.init(frame: CGRect(x: 0, y: 5, width: widthValue, height: 20.0))
        lblMain.textColor = UIColor.white
        lblMain.text = lblText
//        let userDefaults = UserDefaults.standard
        lblMain.textAlignment = .right
//        if (userDefaults.value(forKey: "L") as! String) == "1" {
//            lblMain.textAlignment = .left
//
//        }
        
        lblMain.font = UIFont.init(name: "SFProText-Regular", size: (UIScreen.main.bounds.height / 568) * 10.0)
		let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: widthValue, height: 30.0))
        button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
		button.backgroundColor = UIColor.clear
		
        viewMain.addSubview(lblMain)
        viewMain.addSubview(button)
		let barButtonItem = UIBarButtonItem.init(customView: viewMain)
        target.navigationItem.setRightBarButton(barButtonItem, animated: true)
	}
    
    
    func addLeftButtonWithTitle(_ target: UIViewController, selector: Selector , lblText : String ,widthValue : Double ) {
        
        
        let viewMain  = UIView.init(frame: CGRect(x: 0, y: 0, width: widthValue, height: 30.0))
        viewMain.backgroundColor = UIColor.clear
        
        let viewBg  = UIView.init(frame: CGRect(x: 0, y: 29, width: widthValue , height: 1.0))
        viewBg.backgroundColor = UIColor.white
        
        viewBg.center = CGPoint.init(x:viewMain.center.x , y: viewBg.center.y)
        
        let lblMain = UILabel.init(frame: CGRect(x: 0, y: 10, width: widthValue, height: 20.0))
        lblMain.textColor = UIColor.white
        lblMain.text = lblText
        lblMain.textAlignment = .center
        lblMain.font = UIFont.init(name: "SFProText-Regular", size: (UIScreen.main.bounds.height / 568) * 10.0)
        
        
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: widthValue, height: 30.0))
        button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.clear
        
        viewMain.addSubview(lblMain)
        viewMain.addSubview(button)
        viewMain.addSubview(viewBg)
        
        let barButtonItem = UIBarButtonItem.init(customView: viewMain)
        target.navigationItem.setLeftBarButton(barButtonItem, animated: true)
    }
    
    
   

    func addWhiteBackButtonOn(_ target: UIViewController, selector: Selector) {
        
        let ViewMain = UIView.init(frame: CGRect(x: 0, y: 0, width: 45.0, height: 35.0))
        ViewMain.backgroundColor = UIColor.clear
        
        
        let imgViewMain = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 17.0, height: 17.0))
        imgViewMain.image = UIImage.init(named: "Back")
        imgViewMain.contentMode = .scaleAspectFit
        imgViewMain.backgroundColor = UIColor.clear
        
        imgViewMain.center = CGPoint.init(x: imgViewMain.center.x, y: ViewMain.center.y)
        
        //        let userDefaults = UserDefaults.standard
        //        if (userDefaults.value(forKey: "L") != nil) {
        //            if (userDefaults.value(forKey: "L") as! String) == "1" {
        //                imgViewMain.center = CGPoint.init(x: imgViewMain.center.x + 25, y: ViewMain.center.y)
        //            }
        //        }
        //
        
        let button = UIButton.init(frame: ViewMain.frame)
        button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        
        ViewMain.addSubview(imgViewMain)
        ViewMain.addSubview(button)
        let barButtonItem = UIBarButtonItem.init(customView: ViewMain)
        target.navigationItem.leftBarButtonItem = barButtonItem
        target.navigationItem.setHidesBackButton(true, animated:true);
    }
    
	
	func addBackButtonOn(_ target: UIViewController, selector: Selector) {
        
        let ViewMain = UIView.init(frame: CGRect(x: 0, y: 0, width: 45.0, height: 35.0))
        ViewMain.backgroundColor = UIColor.clear
        
        let imgViewMain = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 17.0, height: 17.0))
        imgViewMain.image = UIImage.init(named: "Back")
        imgViewMain.contentMode = .scaleAspectFit
        imgViewMain.backgroundColor = UIColor.clear
        
        imgViewMain.center = CGPoint.init(x: imgViewMain.center.x, y: ViewMain.center.y)
        
        
		let button = UIButton.init(frame: ViewMain.frame)
        button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        
        ViewMain.addSubview(imgViewMain)
		ViewMain.addSubview(button)
		let barButtonItem = UIBarButtonItem.init(customView: ViewMain)
        target.navigationItem.leftBarButtonItem = barButtonItem
        target.navigationItem.setHidesBackButton(true, animated:true);
	}
    
    func addOrangeBackButtonOn(_ target: UIViewController, selector: Selector) {
        
        let ViewMain = UIView.init(frame: CGRect(x: 0, y: 0, width: 45.0, height: 35.0))
        ViewMain.backgroundColor = UIColor.clear
        
        
        let imgViewMain = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 17.0, height: 17.0))
        imgViewMain.image = UIImage.init(named: "BackO")
        imgViewMain.contentMode = .scaleAspectFit
        imgViewMain.backgroundColor = UIColor.clear
        
        imgViewMain.center = CGPoint.init(x: imgViewMain.center.x, y: ViewMain.center.y)
        
//        let userDefaults = UserDefaults.standard
//        if (userDefaults.value(forKey: "L") != nil) {
//            if (userDefaults.value(forKey: "L") as! String) == "1" {
//                imgViewMain.center = CGPoint.init(x: imgViewMain.center.x + 25, y: ViewMain.center.y)
//            }
//        }
        
        
        let button = UIButton.init(frame: ViewMain.frame)
        button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
        
        ViewMain.addSubview(imgViewMain)
        ViewMain.addSubview(button)
        let barButtonItem = UIBarButtonItem.init(customView: ViewMain)
        target.navigationItem.leftBarButtonItem = barButtonItem
        target.navigationItem.setHidesBackButton(true, animated:true);
    }
}


class UINavigationBarGradientView: UIView {

    enum Point {
        case topRight, topLeft
        case bottomRight, bottomLeft
        case custom(point: CGPoint)

        var point: CGPoint {
            switch self {
                case .topRight: return CGPoint(x: 1, y: 0)
                case .topLeft: return CGPoint(x: 0, y: 0)
                case .bottomRight: return CGPoint(x: 1, y: 1)
                case .bottomLeft: return CGPoint(x: 0, y: 1)
                case .custom(let point): return point
            }
        }
    }

    private weak var gradientLayer: CAGradientLayer!

    convenience init(colors: [UIColor], startPoint: Point = .topLeft,
                     endPoint: Point = .bottomLeft, locations: [NSNumber] = [0, 1]) {
        self.init(frame: .zero)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
        set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
        backgroundColor = .clear
    }

    func set(colors: [UIColor], startPoint: Point = .topLeft,
             endPoint: Point = .bottomLeft, locations: [NSNumber] = [0, 1]) {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        gradientLayer.locations = locations
    }

    func setupConstraints() {
        guard let parentView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        parentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        parentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = gradientLayer else { return }
        gradientLayer.frame = frame
        superview?.addSubview(self)
    }
}

extension UINavigationBar {
    func setGradientBackground(colors: [UIColor],
                               startPoint: UINavigationBarGradientView.Point = .topLeft,
                               endPoint: UINavigationBarGradientView.Point = .bottomLeft,
                               locations: [NSNumber] = [0, 1]) {
        guard let backgroundView = value(forKey: "backgroundView") as? UIView else { return }
        guard let gradientView = backgroundView.subviews.first(where: { $0 is UINavigationBarGradientView }) as? UINavigationBarGradientView else {
            let gradientView = UINavigationBarGradientView(colors: colors, startPoint: startPoint,
                                                           endPoint: endPoint, locations: locations)
            backgroundView.addSubview(gradientView)
            gradientView.setupConstraints()
            return
        }
        gradientView.set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
    }
}
