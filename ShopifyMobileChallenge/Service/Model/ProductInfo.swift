//
//  ProductInfo.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/19.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import Foundation

struct ProductInfo: Decodable {
    var collectionId: Int
    var productId: Int

    private enum CodingKeys: String, CodingKey {
        case collectionId = "collection_id"
        case productId = "product_id"
    }
}
