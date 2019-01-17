//
//  ShopifyService.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/17.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import UIKit
import Moya

enum ShopifyService {
    case collections(page: Int)
    case productList(ofCollection: Int, page: Int)
    case productDetail(ofIds: [Int], page: Int)
}

extension ShopifyService: TargetType {

    var baseURL: URL { return URL(string: "https://shopicruit.myshopify.com")! }
    var headers: [String : String]? { return nil }
    var method: Moya.Method { return .get }

    var path: String {
        switch self {
        case .collections:
            return "/admin/custom_collections.json"
        case .productList:
            return "/admin/collects.json"
        case .productDetail:
            return "/admin/products.json"
        }
    }

    var parameters: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
        case let .collections(page):
            params = ["page": page]

        case let .productList(collectionId, page):
            params = ["collection_id": collectionId, "page": page]

        case let .productDetail(ids, page):
            params = ["ids": ids, "page": page]
        }

        /**
         hard-coded token
         supposed to retrieve from KeyChain or memory cache
        */
        params["access_token"] = "c32313df0d0ef512ca64d5b336a0d7c6"

        return params
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var task: Task {
        return .requestParameters(parameters: self.parameters, encoding: URLEncoding.queryString)
    }

    var sampleData: Data {
        return Data()
    }
}
