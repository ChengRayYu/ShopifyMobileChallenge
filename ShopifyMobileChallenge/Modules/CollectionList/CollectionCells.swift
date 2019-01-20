//
//  CollectionCells.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/20.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import UIKit
import RxSwift

class CollectionCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!

}

class CollectionErrorCell: UITableViewCell {

    @IBOutlet weak var errMsgLbl: UILabel!
    @IBOutlet weak var reloadBtn: UIButton!
    private(set) var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
