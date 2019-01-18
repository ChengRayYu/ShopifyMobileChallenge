//
//  CollectionService.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/18.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import Foundation
import Moya

enum CollectionService {
    case collections(page: Int)
    case productList(ofCollection: Int, page: Int)
    case productDetail(ofIds: [Int], page: Int)
}

extension CollectionService: TargetType, ServiceBase {

    var baseURL: URL { return URL(string: url)! }
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
        switch self {
        case let .collections(page):
            return ["page": page, "access_token": token]

        case let .productList(collectionId, page):
            return ["collection_id": collectionId, "page": page, "access_token": token]

        case let .productDetail(ids, page):
            return ["ids": ids, "page": page, "access_token": token]
        }
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
