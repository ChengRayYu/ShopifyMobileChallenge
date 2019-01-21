//
//  ProductListController.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/20.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

class ProductListController: UIViewController {

    @IBOutlet private weak var productTable: UITableView!

    var viewModel: ProductListViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        rx()
    }    
}

// MARK: - Private Functions

extension ProductListController {

    private func rx() {

        productTable.rx.setDelegate(self).disposed(by: disposeBag)
        
        let tableDataSrc = RxTableViewSectionedReloadDataSource<SectionModel<String, ProductListViewModel.CellModel>>(
            configureCell: { [weak self] (dataSrc, table, indexPath, element) -> UITableViewCell in
                switch element {
                case let .product(title, imageUrl, vendor, inStock, updated):
                    let cell = table.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
                    cell.iconImgView.kf.setImage(with: URL(string: imageUrl))
                    cell.titleLbl.text = title
                    cell.vendorLbl.text = vendor
                    cell.inStockNumLbl.text = "\(inStock)"
                    cell.updateLbl.text = updated
                    return cell

                case let .error(msg):
                    let cell = table.dequeueReusableCell(withIdentifier: "ProductErrorCell", for: indexPath) as! ProductErrorCell
                    cell.errMsgLbl.text = msg
                    if let reloadSubject = self?.viewModel.reloadSubject {
                        cell.reloadBtn.rx.tap.asDriver().drive(reloadSubject).disposed(by: cell.disposeBag)
                    }
                    return cell
                }
        })

        viewModel.productsDrv
            .map({ (items) -> [SectionModel<String, ProductListViewModel.CellModel>] in
                return [SectionModel(model: "", items: items)]
            })
            .drive(productTable.rx.items(dataSource: tableDataSrc))
            .disposed(by: disposeBag)
    }
}

extension ProductListController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
