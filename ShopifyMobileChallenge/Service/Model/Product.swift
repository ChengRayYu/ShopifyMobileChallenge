//
//  Product.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/17.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import Foundation

struct Product: Decodable {
    var id: Int?
    var title: String?
    var body: String?
    var type: String?
    var vendor: String?
    var updated: String?
    var variants: [ProductVariant]?
    var image: ProductImage?

    private enum CodingKeys: String, CodingKey {
        case body = "body_html"
        case type = "product_type"
        case updated = "updated_at"
        case id, title, vendor
    }
}
