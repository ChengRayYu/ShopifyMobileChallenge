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
            .map({ (response) -> [Collection] in
                do {
                    return try response.map([Collection].self, atKeyPath: "custom_collections", using: JSONDecoder(), failsOnEmptyData: true)
                } catch {
                    throw Err.serialization
                }
            })
            .map({ (collections) -> Response<[Collection]> in
                return Response.success(value: collections)
            })
            .catchError({ (err) -> Single<Response<[Collection]>> in
                return Single.just(.fail(err: handleError(err)))
            })
    }

    
}

private extension ShopifyServices {

    static func handleError(_ error: Error) -> Err {
        return error as? Err ?? .service(msg: error.localizedDescription)
    }
}
