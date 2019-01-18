//
//  ShopifyService+Response.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/18.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import Foundation

extension ShopifyServices {

    enum Response<V> {
        case success(value: V)
        case fail(err: Err)
    }

    enum Err: Error {
        case serialization
        case service(msg: String)

        var description: String {
            switch self {
            case .serialization:        return "Serialization"
            case .service(let msg):     return msg
            }
        }
    }
}
