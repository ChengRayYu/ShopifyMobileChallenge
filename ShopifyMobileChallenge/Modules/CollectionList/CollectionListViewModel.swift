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

    enum CellType {
        case collection(id: Int?, title: String?, imageUrl: String?)
        case empty
        case error(msg: String)
    }

    private (set) var listDrv: Driver<[CellType]>
    private (set) var reloadSubject: PublishSubject<Void>

    init() {

        reloadSubject = PublishSubject<Void>()

        listDrv = reloadSubject.asDriver(onErrorJustReturn: ()).startWith(())
            .flatMap({ _ -> Driver<[CellType]> in
                return ShopifyServices.findAllCollections()
                    .map({ (response) -> [CellType] in
                        switch response {
                        case .success(let value):
                            guard !value.isEmpty else {
                                return [.empty]
                            }
                            return value.map { .collection(id: $0.id, title: $0.title, imageUrl: $0.image?.src) }
                        case .fail(let err):
                            return [.error(msg: err.localizedDescription)]
                        }
                    })
                    .asDriver(onErrorJustReturn: [])
            })
    }
}
