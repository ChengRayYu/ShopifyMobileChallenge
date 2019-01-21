//
//  ProductListCells.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/20.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import UIKit
import RxSwift

class ProductHeader: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bodyLbl: UILabel!
}

class ProductCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var vendorLbl: UILabel!
    @IBOutlet weak var inStockNumLbl: UILabel!
    @IBOutlet weak var updateLbl: UILabel!

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        bgView.backgroundColor = (highlighted) ? UIColor(named: "Background") : .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bgView.backgroundColor = (selected) ? UIColor(named: "Background") : .white
    }
}

class ProductErrorCell: UITableViewCell {
    @IBOutlet weak var errMsgLbl: UILabel!
    @IBOutlet weak var reloadBtn: UIButton!

    private(set) var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
