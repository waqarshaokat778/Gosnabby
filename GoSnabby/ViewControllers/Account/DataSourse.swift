//
//  DataSourse.swift
//  GoSnabby
//
//  Created by Abdullah on 2/20/21.
//

import Foundation

public struct SettingOptionsModal {
    
    var name: String
    var iconName: String
    var navigationVCName: String?
    var storyBoardName: String?
    
    internal init(name: String, iconName: String, navigationVCName: String?, storyBoardName: String?) {
        self.name = name
        self.iconName = iconName
        self.navigationVCName = navigationVCName
        self.storyBoardName = storyBoardName
    }
    
}

public var settingOptionsData: [SettingOptionsModal] = [
//    SettingOptionsModal(name: "Payment Methods", iconName: "paymentIcon", navigationVCName: nil, storyBoardName: nil),
    SettingOptionsModal(name: "My Orders", iconName: "OrderHistory", navigationVCName: "OrderHistoryVC", storyBoardName: "OrderHistory"),
    SettingOptionsModal(name: "Help", iconName: "helpIcon", navigationVCName: "HelpVC", storyBoardName: "AboutUs"),
    SettingOptionsModal(name: "About", iconName: "aboutUsIcon",  navigationVCName: "AboutUsVC", storyBoardName: "AboutUs"),
    SettingOptionsModal(name: "Privacy Policy", iconName: "privacypolicyIcon", navigationVCName: "PrivacyVC", storyBoardName: "AboutUs"),
                    ]

