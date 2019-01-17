//
//  ViewController.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/17.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let service = MoyaProvider<ShopifyService>()

        service.rx.request(.collections(page: 1))
            .subscribe { (event) in

                switch event {
                case let .success(response):
                    print(response)

                case let .error(error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }


}

