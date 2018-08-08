//
//  ArticleListTableDataSource.swift
//  RxQiita
//
//  Created by 櫻井寛海 on 2018/08/08.
//  Copyright © 2018 Hiromi Sakurai. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ArticleListTableDataSource: NSObject {
    var items: [ArticleListTableCellModel] = []
    let selectedCellModel: Observable<ArticleListTableCellModel>
    private let didSelectCell = PublishRelay<ArticleListTableCellModel>()

    override init() {
        selectedCellModel = didSelectCell.asObservable()
    }
}

extension ArticleListTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(indexPath: indexPath) as ArticleListTableCell
        cell.config(title: items[indexPath.row].title, likesCount: items[indexPath.row].likesCount, date: items[indexPath.row].createdAt)
        return cell
    }
}

extension ArticleListTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCell.accept(items[indexPath.row])
    }
}

extension ArticleListTableDataSource: RxTableViewDataSourceType {
    typealias Element = [ArticleListTableCellModel]

    func tableView(_ tableView: UITableView, observedEvent: Event<[ArticleListTableCellModel]>) {
        Binder(self) { dataSource, element in
            dataSource.items = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }
}

//extension ArticleListTableDataSource: SectionedViewDataSourceType {
//    func model(at indexPath: IndexPath) throws -> Any {
//        return items[indexPath.row]
//    }
//}
