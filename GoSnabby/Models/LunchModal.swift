//
//  LunchModal.swift
//  GoSnabby
//
//  Created by Abdullah on 2/25/21.
//

import Foundation

struct LunchModal: Decodable {
    let status: Int?
    let message: String?
    let data: [LunchMeal]?
}

struct LunchMeal: Decodable {
    let id, schoolID: Int?
    let name: String?
    let price: String?
    let deals: [Deal]?
    let dateFrom, dateTo, dealImage, detail, description, createdAt: String?
    let updatedAt: String?
    let available_deals: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case schoolID = "school_id"
        case name, price, deals, detail, description, available_deals
        case dateFrom = "date_from"
        case dateTo = "date_to"
        case dealImage = "deal_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Deal: Decodable {
    let id: Int?
    let name: String?
    let isLike: Bool?
    let dealDescription, availableItems, image, price: String?
    let categoryID: Int?
    let updatedAt, createdAt: String?
    let quantity, schoolID: Int?
    let productType, detail: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isLike = "is_like"
        case dealDescription = "description"
        case availableItems = "available_items"
        case image, price
        case categoryID = "category_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case schoolID = "school_id"
        case productType = "product_type"
        case detail
        case quantity
    }
}
