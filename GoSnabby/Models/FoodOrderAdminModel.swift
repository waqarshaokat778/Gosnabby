//
//  FoodOrderAdminModel.swift
//  GoSnabby
//
//  Created by Abdullah on 3/3/21.
//

import Foundation

// MARK: - Welcome
struct FoodOrderAdminModel: Codable {
    let status: Int?
    let message: String?
    let data: [FoodOrderDataModel]?
}
    struct FoodOrderDataModel: Codable {
        let id, userID: Int?
        let amount : Double?
        let transactionID, paymentType: String?
        let departmentID: Int?
        let numProduct, productData, createdAt, updatedAt: String?
        let schoolID: Int?
        let status, depName, userName: String?
        let productsListings: [ProductsListingModel]?
        let orderDescription: String?

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case amount
            case transactionID = "transaction_id"
            case paymentType = "payment_type"
            case departmentID = "department_id"
            case numProduct = "num_product"
            case productData = "product_data"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case schoolID = "school_id"
            case status
            case depName = "dep_name"
            case userName = "user_name"
            case productsListings = "products_listings"
            case orderDescription = "order_case_description"
        }
        

        // MARK: - ProductsListing
        struct ProductsListingModel: Codable {
            let id: Int?
            let name: String?
            let isLike: Int?
            let productsListingDescription, availableItems, image, price: String?
            let categoryID: Int?
            let updatedAt, createdAt: String?
            let schoolID: Int?
            let productType, detail, quantity: String?

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
                case detail, quantity
            }
        }
    }


struct LunchOrderAdminModel: Codable {
    let status: Int?
    let message: String?
    let data: [LunchOrderDataModel]?

}
    // MARK: - Datum
    struct LunchOrderDataModel: Codable {
        let id, userID, schoolID, depID: Int?
        let amount: Double?
        let transactionID, paymentType: String?
        let orderData: [OrderDataModel]?
        let orderDate: String?
        let orderStatus: Int?
        let createdAt, updatedAt, userName: String?
        let productsListings: [ProductsListing]?
        let lunchDealQuantity: Int?
        let lunchDealName, lunchDealImage, lunchDealDetail, datumDescription: String?

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case schoolID = "school_id"
            case depID = "dep_id"
            case amount
            case transactionID = "transaction_id"
            case paymentType = "payment_type"
            case orderData = "order_data"
            case orderDate = "order_date"
            case orderStatus = "order_status"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case userName = "user_name"
            case productsListings = "products_listings"
            case lunchDealQuantity = "lunch_deal_quantity"
            case lunchDealName = "lunch_deal_name"
            case lunchDealImage = "lunch_deal_image"
            case lunchDealDetail = "lunch_deal_detail"
            case datumDescription = "description"
        }
    

    // MARK: - OrderDatum
    struct OrderDataModel: Codable {
        let id, quantity: Int?
//        let deal: DealList?
        
    }

    // MARK: - Deal
    struct DealList: Codable {
        let id, schoolID: Int?
        let name: String?
        let price: Double?
        let deals, dateFrom, dateTo, dealImage: String?
        let detail, dealDescription: String?
        let availableDeals: Int?
        let createdAt, updatedAt: String?

        enum CodingKeys: String, CodingKey {
            case id
            case schoolID = "school_id"
            case name, price, deals
            case dateFrom = "date_from"
            case dateTo = "date_to"
            case dealImage = "deal_image"
            case detail
            case dealDescription = "description"
            case availableDeals = "available_deals"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }

    // MARK: - ProductsListing
    struct ProductsListing: Codable {
        let productID: Int?
        let productImage, productName, productPrice: String?
        let productQuantity: Int?

        enum CodingKeys: String, CodingKey {
            case productID = "product_id"
            case productImage = "product_image"
            case productName = "product_name"
            case productPrice = "product_price"
            case productQuantity = "product_quantity"
        }
        
       
    }

}
