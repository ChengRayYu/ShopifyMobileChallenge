//
//  ServiceBase.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/18.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import Foundation

protocol ServiceBase {
    var url: String { get }
    var token: String { get }
}

extension ServiceBase {
    var url: String {
        return "https://shopicruit.myshopify.com"
    }

    /**
     hard-coded token
     supposed to be retreived from KeyChain or memory cache
     */
    var token: String {
        return "c32313df0d0ef512ca64d5b336a0d7c6"
    }
}
