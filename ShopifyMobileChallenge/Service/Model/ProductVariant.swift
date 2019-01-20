//
//  Variant.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/17.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import Foundation

struct ProductVariant: Decodable {
    var id: Int?
    var title: String?
    var price: String?
    var inventoryQuantity: Int?

    private enum CodingKeys: String, CodingKey {
        case inventoryQuantity = "inventory_quantity"
        case id, title, price
    }    
}
