//
//  CollectionListViewModel.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/20.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class CollectionListViewModel {

    enum CellModel {
        case collection(id: Int, title: String, body: String, imageUrl: String)
        case empty
        case error(msg: String)
    }

    private (set) var listDrv: Driver<[CellModel]>
    private (set) var reloadSubject: PublishSubject<Void>

    init() {

        reloadSubject = PublishSubject<Void>()

        listDrv = reloadSubject.asDriver(onErrorJustReturn: ()).startWith(())
            .flatMap({ _ -> Driver<[CellModel]> in
                return ShopifyServices.findAllCollections()
                    .map({ (response) -> [CellModel] in
                        switch response {
                        case .success(let value):
                            guard !value.isEmpty else {
                                return [.empty]
                            }
                            return value.map {
                                .collection(id: $0.id ?? 0,
                                            title: $0.title ?? "",
                                            body: $0.body ?? "",
                                            imageUrl: $0.image?.src ?? "")
                            }
                        case .fail(let err):
                            return [.error(msg: err.localizedDescription)]
                        }
                    })
                    .asDriver(onErrorJustReturn: [])
            })
    }
}
