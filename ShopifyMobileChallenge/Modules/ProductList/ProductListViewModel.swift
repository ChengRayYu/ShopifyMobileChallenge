//
//  ProductListViewModel.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/20.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProductListViewModel {

    enum CellModel {
        case product(title: String, imageUrl: String, vendor: String, inStock: Int, updated: String)
        case error(msg: String)
    }

    private (set) var productsDrv: Driver<[CellModel]>
    private (set) var reloadSubject: PublishSubject<Void>

    init(withCollectionId collectionId: Int) {

        reloadSubject = PublishSubject<Void>()

        productsDrv = reloadSubject.asDriver(onErrorJustReturn: ()).startWith(())
            .flatMap({ _ -> Driver<[CellModel]> in
                return ShopifyServices.findProductList(ofCollection: collectionId)
                    .map({ (response) -> (ids: [Int]?, error: Error?) in
                        switch response {
                        case .success(value: let value):
                            return (value, nil)
                        case .fail(let err):
                            return (nil, err)
                        }
                    })
                    .flatMap({ (productListResult) -> Single<[CellModel]> in
                        guard let ids = productListResult.ids else {
                            return Single.just([.error(msg: productListResult.error!.localizedDescription)])
                        }
                        return ShopifyServices.findProductDetails(ofIds: ids)
                            .map({ (response) -> [CellModel] in
                                switch response {
                                case .success(let value):
                                    guard !value.isEmpty else {
                                        return [.error(msg: "Collections Not Found")]
                                    }
                                    return value.map({ (product) -> CellModel in
                                        let inStockNum = product.variants?.reduce(0, { $0 + ($1.inventoryQuantity ?? 0) })
                                        let model = CellModel.product(title: product.title ?? "",
                                                               imageUrl: product.image?.src ?? "",
                                                               vendor: product.vendor ?? "" ,
                                                               inStock: inStockNum ?? 0,
                                                               updated: "Last Updated - " + (product.updated ?? "").toDateFormat("MMM dd HH:mm"))
                                        return model
                                    })
                                case .fail(let err):
                                    return [.error(msg: err.localizedDescription)]
                                }
                            })
                    })
                    .asDriver(onErrorJustReturn: [])
            })
    }
}

fileprivate extension String {

    func toDateFormat(_ format: String) -> String {

        //2018-12-17T13:52:16-05:00

        print(self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
