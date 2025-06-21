//
//  AccountVC.swift
//  GoSnabby
//
//  Created by Abdullah on 2/20/21.
//

import UIKit

class AccountVC: BaseVC {

    @IBOutlet weak var profileImgView: UIView!
    @IBOutlet weak var profileImage: UIImageView!{
        didSet {
            profileImage.layer.cornerRadius = profileImage.frame.width / 2
            profileImage.borderWidth = 0.5
            profileImage.borderColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var navigationsTblView: UITableView!
    @IBOutlet weak var logoutView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationsTblView.delegate = self
        self.navigationsTblView.dataSource = self
        self.navigationsTblView.register(UINib.init(nibName: "SettingOptionCell", bundle: nil), forCellReuseIdentifier: "SettingOptionCell")
        
        let editProfileTap = UITapGestureRecognizer.init(target: self, action: #selector(editProfile))
        profileImgView.isUserInteractionEnabled = true
        profileImgView.addGestureRecognizer(editProfileTap)
        
    }
    
    @objc func editProfile(_ tap: UITapGestureRecognizer) {
        self.PushViewWithStoryBoard(name: kConstantsStoryBoard.UpdateProfile, StoryBoard: "UpdateProfile")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.TabbarHide(status: false)
        self.navigationClear()
        self.NavigationHide(status: true)
        
        self.email.text = DataManager.sharedInstance.user?.email
        self.username.text = DataManager.sharedInstance.user?.user_name
        let newURL = kBaseUserImageURL + DataManager.sharedInstance.user!.profile_image
        self.downloadImage(imgview: self.profileImage, URL: newURL)
        
    }
    
    @IBAction func logout(sender : UIButton){
        ShowAlertWithCompletaion(title: "", message: "Are you sure to logout?", isError: false, DismissButton: "No", AcceptButton: "Yes") { (response) in
            if response {
                DataManager.sharedInstance.logoutUser()
                self.dismiss(animated: true) {
                }
            }
        }
        
    }
    
    
}

extension AccountVC :  UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptionsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingOptionCell = tableView.dequeueReusableCell(withIdentifier: "SettingOptionCell", for: indexPath) as! SettingOptionCell
        settingOptionCell.selectionStyle = .none
        settingOptionCell.optionName.text = settingOptionsData[indexPath.row].name
        settingOptionCell.optionIcon.image = UIImage(named: settingOptionsData[indexPath.row].iconName)
        return settingOptionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (settingOptionsData[indexPath.row].navigationVCName != nil) && (settingOptionsData[indexPath.row].storyBoardName != nil)  {
            self.PushViewWithStoryBoard(name: settingOptionsData[indexPath.row].navigationVCName!, StoryBoard:  settingOptionsData[indexPath.row].storyBoardName!)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

