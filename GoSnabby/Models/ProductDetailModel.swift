//
//  ProductDetailModel.swift
//  GoSnabby
//
//  Created by Abdullah on 6/23/21.
//

import Foundation

struct ProductDetailModel: Codable {
    
    var id: Int?
    var name: String?
    let isLike: Int?
    var description, availableItems, image, price: String?
    let categoryID: Int?
    let updatedAt, createdAt: String?
    let schoolID: Int?
    var productType, detail: String?
    let softDelete: Int?
    let barcode: String?
    var quantity: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isLike = "is_like"
        case description = "description"
        case availableItems = "available_items"
        case image, price
        case categoryID = "category_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case schoolID = "school_id"
        case productType = "product_type"
        case detail
        case softDelete = "soft_delete"
        case barcode
        case quantity
    }
    
    internal init(id: Int? = nil, name: String? = nil, isLike: Int? = nil, description: String? = nil, availableItems: String? = nil, image: String? = nil, price: String? = nil, categoryID: Int? = nil, updatedAt: String? = nil, createdAt: String? = nil, schoolID: Int? = nil, productType: String? = nil, detail: String? = nil, softDelete: Int? = nil, barcode: String? = nil, quantity: Int? = nil) {
        self.id = id
        self.name = name
        self.isLike = isLike
        self.description = description
        self.availableItems = availableItems
        self.image = image
        self.price = price
        self.categoryID = categoryID
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.schoolID = schoolID
        self.productType = productType
        self.detail = detail
        self.softDelete = softDelete
        self.barcode = barcode
        self.quantity = quantity
    }
    
}


struct LunchDetailModel: Codable {
    var id, schoolID: Int?
    var name: String?
    var price: String?
    var dateFrom, dateTo, weekNumber: String?
    var dealImage, detail, description: String?
    var availableDeals: Int?
    var createdAt, updatedAt, barcode: String?
    var productdetail: [ProductDetailModel]?

    enum CodingKeys: String, CodingKey {
        case id
        case schoolID = "school_id"
        case name, price
        case dateFrom = "date_from"
        case dateTo = "date_to"
        case weekNumber = "week_number"
        case dealImage = "deal_image"
        case detail
        case description = "description"
        case availableDeals = "available_deals"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case barcode, productdetail
    }
    
    internal init(id: Int? = nil, schoolID: Int? = nil, name: String? = nil, price: String? = nil, dateFrom: String? = nil, dateTo: String? = nil, weekNumber: String? = nil, dealImage: String? = nil, detail: String? = nil, description: String? = nil, availableDeals: Int? = nil, createdAt: String? = nil, updatedAt: String? = nil, barcode: String? = nil, productdetail: [ProductDetailModel]? = nil) {
        self.id = id
        self.schoolID = schoolID
        self.name = name
        self.price = price
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.weekNumber = weekNumber
        self.dealImage = dealImage
        self.detail = detail
        self.description = description
        self.availableDeals = availableDeals
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.barcode = barcode
        self.productdetail = productdetail
    }
}

  
