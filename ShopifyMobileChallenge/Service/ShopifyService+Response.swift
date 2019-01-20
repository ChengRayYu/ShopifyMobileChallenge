//
//  ShopifyService+Response.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/18.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import Foundation
import Moya

extension ShopifyServices {
    enum Response<V> {
        case success(value: V)
        case fail(err: Error)
    }
}
