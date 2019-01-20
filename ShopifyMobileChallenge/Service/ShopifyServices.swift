//
//  ShopifyServices.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/17.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class ShopifyServices {

    // collections api provider instance
    private static let collectionProvider = MoyaProvider<CollectionService>()

    static func findAllCollections(atPage page: Int = 1) -> Single<Response<[Collection]>> {
        return collectionProvider.rx.request(.collections(page: page))
            .filterSuccessfulStatusCodes()
            .map({ (response) -> [Collection] in
                do {
                    return try response.map([Collection].self, atKeyPath: "custom_collections", using: JSONDecoder(), failsOnEmptyData: false)
                }
            })
            .map({ (collections) -> Response<[Collection]> in
                return Response.success(value: collections)
            })
            .catchError({ (err) -> Single<Response<[Collection]>> in
                return Single.just(.fail(err: err))
            })
    }    

    static func findProductList(ofCollection collectionId: Int, atPage page: Int = 1) -> Single<Response<[Int]>> {

        return collectionProvider.rx.request(.productList(ofCollection: collectionId, page: page))
            .filterSuccessfulStatusCodes()
            .map({ (response) -> [Int] in
                do {
                    let products = try response.map([ProductInfo].self, atKeyPath: "collects", using: JSONDecoder(), failsOnEmptyData: false)
                    return products.map { $0.productId }
                }
            })
            .map({ (ids) -> Response<[Int]> in
                return Response.success(value: ids)
            })
            .catchError({ (err) -> Single<Response<[Int]>> in
                return Single.just(.fail(err: err))
            })
    }

    static func findProductDetails(ofIds ids: [Int], atPage page: Int = 1) -> Single<Response<[Product]>> {

        return collectionProvider.rx.request(.productDetails(ofIds: ids, page: page))
            .filterSuccessfulStatusCodes()
            .map({ (response) -> [Product] in
                do {
                    return try response.map([Product].self, atKeyPath: "", using: JSONDecoder(), failsOnEmptyData: false)
                }
            })
            .map({ (details) -> Response<[Product]> in
                return Response.success(value: details)
            })
            .catchError({ (err) -> Single<Response<[Product]>> in
                return Single.just(.fail(err: err))
            })
    }
}
