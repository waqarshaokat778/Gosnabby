//
//  OrderHistoryModel.swift
//  GoSnabby
//
//  Created by Abdullah on 5/28/21.
//

import Foundation

struct OrderHistoryModel: Codable {
    let status: Int?
    let message: String?
    let data: [OrderHistoryData]?
}

// MARK: - Datum
struct OrderHistoryData: Codable {
    let id, userID : Int?
    let amount: Double?
//    let transactionID: JSONNull?
    let paymentType: String?
    let departmentID: Int?
    let numProduct, productData: String?
    let orderCase: Int?
    let orderCaseDescription, createdAt, updatedAt: String?
    let schoolID: Int?
    let status, depName, stripeChargeID: String?
    let feesCollected, paidOut, totalProduct: Double?
    let productsListings: [OrderProductsList]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case amount
//        case transactionID = "transaction_id"
        case paymentType = "payment_type"
        case departmentID = "department_id"
        case numProduct = "num_product"
        case productData = "product_data"
        case orderCase = "order_case"
        case orderCaseDescription = "order_case_description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case schoolID = "school_id"
        case status
        case depName = "dep_name"
        case stripeChargeID = "stripe_charge_id"
        case feesCollected = "fees_collected"
        case paidOut = "paid_out"
        case totalProduct = "total_product"
        case productsListings = "products_listings"
    }
}

// MARK: - ProductsListing
struct OrderProductsList: Codable {
    let id: Int?
    let name: String?
    let isLike: Int?
    let productsListingDescription, availableItems, image, price: String?
    let categoryID: Int?
    let updatedAt, createdAt: String?
    let schoolID: Int?
    let productType, detail: String?
    let softDelete: Int?
    let quantity: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isLike = "is_like"
        case productsListingDescription = "description"
        case availableItems = "available_items"
        case image, price
        case categoryID = "category_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case schoolID = "school_id"
        case productType = "product_type"
        case detail
        case softDelete = "soft_delete"
        case quantity
    }
}
