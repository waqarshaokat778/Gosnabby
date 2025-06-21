//
//  LunchHistoryModel.swift
//  GoSnabby
//
//  Created by Abdullah on 2/26/21.
//

import Foundation

struct LunchHistoryModel: Codable {
    let status: Int?
    let message: String?
    let data: [DataLunchHistory]?
}

struct DataLunchHistory: Codable {
    let id, userID, schoolID, depID: Int?
    let amount: Double?
    let transactionID, paymentType: String?
    let orderDate: String?
    let orderStatus: Int?
    let createdAt, updatedAt, userName: String?
    let lunchDealQuantity: Int?
    let lunchDealName, lunchDealImage, lunchDealDetail: String?
    let orderData: [LunchHistoryOrderDataModel]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case schoolID = "school_id"
        case depID = "dep_id"
        case amount
        case transactionID = "transaction_id"
        case paymentType = "payment_type"
        case orderDate = "order_date"
        case orderStatus = "order_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userName = "user_name"
        case lunchDealQuantity = "lunch_deal_quantity"
        case lunchDealName = "lunch_deal_name"
        case lunchDealImage = "lunch_deal_image"
        case lunchDealDetail = "lunch_deal_detail"
        case orderData = "order_data"
        
    }
    
   
}

struct LunchHistoryOrderDataModel: Codable {
    let deal: DealModel?
}

struct DealModel: Codable {
    let dateFrom, dateTo: String?
    
    enum CodingKeys: String, CodingKey {
        case dateFrom = "date_from"
        case dateTo = "date_to"
    }
}

