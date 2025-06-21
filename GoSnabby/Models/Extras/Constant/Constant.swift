//  Constant.swift
//
//
//  Created by waseem shah on 2/27/17.
//  Copyright © 2017 waseem shah. All rights reserved.
//

import Foundation
import UIKit


struct kConstantsColors {
    
    
    static let kNavigationcolor = UIColor.init(red: (252/255), green: (182/255), blue: (20/255), alpha: 1.0)
    static let kWhitecolor = UIColor.init(red: (142/255), green: (145/255), blue: (166/255), alpha: 0.1)
    static let kAppBluecolor = UIColor.init(red: (19/255), green: (215/255), blue: (177/255), alpha: 1.0)
    
}



//MARK:- Messages

struct kConstantsAlert {
    
    static let kEmptyCredentails    = "Please provide your credentails to proceed."
    static let kWrongEmail          = "Incorrect email format. Please provide a valid email address."
}

struct kConstantsStoryBoard {
    
    static let Welcome = "Welcome"
    static let School = "School"
    static let Signin = "Signin"
    static let UpdateProfile = "UpdateProfileVC"
    static let forgotPassword = "ForgotPassword"
    static let Maintabbar = "maintabbar"
    static let MaintabbarForAdmin = "MainTabbarForAdmin"
    static let FoodItemDetails = "FoodItemDetails"
    static let OrderComplete = "OderCompletedVC"
    static let LunchDealsDetail = "LunchDealDetails"
}

struct APIName {
    
    static let getSchool = "get_school_list"
    static let checkUser = "check_user"
    static let checkAdmin = "check_admin"
    static let setNewPassword = "forgot_password_new"
    
    static let getcategories = "get_categories_list"
    static let get_all_like_unlike_product_list = "get_all_like_unlike_product_list"
    static let like_dislike = "like_dislike"
    static let get_like_product_list = "get_like_product_list"
    static let lunchDeals = "lunch_deals_listing"
    static let lunchHistory = "ordered_lunch_meals"
    static let orderHistory = "get-order-history"
    static let getDepartments = "get_department_list"
    static let getEvent = "get_events_list"
    static let lunchDealOrder = "lunch_deal_order"
    static let addFoodOrder = "add_order"
    static let OrderListForAdmin = "order_products_history"
    static let LunchListForAdmin = "ordered_lunch_meals_school_admin"
    static let addCard = "add_card"
    static let checkItemAgainstCode = "get_barcode_detail"
    static let markOrderComplete = "update_order"
    
}


let kErrorTitle				    = "Error"
let kInformationMissingTitle    = "Information Missing"
let kOKBtnTitle				    = "OK"
let kCancelBtnTitle			    = "Cancel"
let kDismissBtnTitle			= "Dismiss"
let kTryAgainBtnTitle		    = "Try Again"
let kEmptyString = ""


let kDescriptionHere = "Description Here..."

var kNetworkNotAvailableMessage = "It appears that you are not connected with internet. Please check your internet connection and try again."
var kServerNotReachableMessage = "We are unable to connect our server at the moment. Please check your device internet settings or try later."
var kFacebookSigninFailedMessage = "We are unable to get your identity from Facebook. Please check your Facebook profile settings and then try again."


var kServerIPAddress: String {
    return "http://manage.gosnabby.com/api/"
}


let kFillHeart = "HeartFill.png"
let kEmptyHeart = "HeartGreen.png"

var kBaseSchoolImageURL: String {
    return "https://manage.gosnabby.com/public/school_image/"
}


var kBaseUserImageURL: String {
    return "https://manage.gosnabby.com/public/user_profile/"
}

var kBaseItemImageURL: String {
    return "https://manage.gosnabby.com/public/item_image/"
}

var kBaseLunchImageURL: String {
    return "https://manage.gosnabby.com/public/lunch_deal/"
}


var kBaseURLString: String {
    
    return "\(kServerIPAddress)"
    
}

var updateProfileNoti = NSNotification.Name(rawValue: "updateProfile")
var updateCartNoti = NSNotification.Name(rawValue: "updateCart")
