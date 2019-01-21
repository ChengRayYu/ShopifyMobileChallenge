//
//  CollectionListController.swift
//  ShopifyMobileChallenge
//
//  Created by Ray on 2019/1/17.
//  Copyright © 2019 chengrayyu.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

class CollectionListController: UIViewController {

    @IBOutlet private weak var collectionTable: UITableView!

    private lazy var viewModel = CollectionListViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionTable.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        rx()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - Private Functions

extension CollectionListController {

    private func rx() {

        collectionTable.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        let tableDataSrc = RxTableViewSectionedReloadDataSource<SectionModel<String, CollectionListViewModel.CellModel>>(
            configureCell: { [weak self] (dataSrc, table, indexPath, element) -> UITableViewCell in

                switch element {
                case let .collection(_ , title, _, imageUrl):
                    let cell = table.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
                    cell.titleLbl.text = title
                    cell.iconImgView.kf.setImage(with: URL(string: imageUrl))
                    return cell

                case .empty:
                    let cell = table.dequeueReusableCell(withIdentifier: "CollectionErrorCell", for: indexPath) as! CollectionErrorCell
                    cell.errMsgLbl.text = "Collections Not Found"
                    if let reloadSubject = self?.viewModel.reloadSubject {
                        cell.reloadBtn.rx.tap.asDriver().drive(reloadSubject).disposed(by: cell.disposeBag)
                    }
                    return cell

                case let .error(msg):
                    let cell = table.dequeueReusableCell(withIdentifier: "CollectionErrorCell", for: indexPath) as! CollectionErrorCell
                    cell.errMsgLbl.text = msg
                    if let reloadSubject = self?.viewModel.reloadSubject {
                        cell.reloadBtn.rx.tap.asDriver().drive(reloadSubject).disposed(by: cell.disposeBag)
                    }
                    return cell
                }
        })

        viewModel.listDrv
            .map({ (items) -> [SectionModel<String, CollectionListViewModel.CellModel>] in
                return [SectionModel(model: "", items: items)]
            })
            .drive(collectionTable.rx.items(dataSource: tableDataSrc))
            .disposed(by: disposeBag)

        collectionTable.rx.modelSelected(CollectionListViewModel.CellModel.self)
            .asObservable()
            .map({ (model) -> (id: Int, title: String, body: String, imageUrl: String)? in
                if case let .collection(id, title, body, image) = model {
                    return (id, title, body, image)
                }
                return nil
            })
            .skipWhile { $0 == nil }
            .subscribe(onNext: { [weak self] (collectionInfo) in
                let productListVC = UIStoryboard(name: "Products", bundle: Bundle.main)
                    .instantiateViewController(withIdentifier: "ProductListController") as? ProductListController
                guard let productList = productListVC, let info = collectionInfo else { return }
                productList.viewModel = ProductListViewModel(withCollectionId: info.id,
                                                             title: info.title,
                                                             body: info.body,
                                                             imageUrl: info.imageUrl)
                self?.navigationController?.pushViewController(productList, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension CollectionListController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
