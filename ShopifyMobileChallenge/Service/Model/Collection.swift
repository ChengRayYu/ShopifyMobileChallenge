//
//  Collection.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/17.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import Foundation

struct Collection: Decodable {
    var id: Int?
    var title: String?
    var body: String?
    var updated: String?
    var image: CollectionImage?

    private enum CodingKeys: String, CodingKey {
        case updated = "updated_at"
        case body = "body_html"
        case id, title, image
    }
}
