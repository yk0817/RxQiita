//
//  ArticleListViewModel.swift
//  RxQiita
//
//  Created by 櫻井寛海 on 2018/07/26.
//  Copyright © 2018 Hiromi Sakurai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ArticleListViewModelProtocol {
    func getArticleListStream() -> Signal<[ArticleListTableCellModel]>
    func updateArticleList(searchQuery: String, isAdditional: Bool)
}

final class ArticleListViewModel {

    private let usecase: ArticleListUsecaseProtocol
    private let mapper: ArticleListViewModelMapperProtocol
    private var dataSource: [ArticleListTableCellModel]

    private let disposeBag = DisposeBag()

    init(usecase: ArticleListUsecaseProtocol, mapper: ArticleListViewModelMapperProtocol) {
        self.usecase = usecase
        self.mapper = mapper
        self.dataSource = []
    }
}

extension ArticleListViewModel: ArticleListViewModelProtocol {

    func getArticleListStream() -> Signal<[ArticleListTableCellModel]> {
        return usecase.getArticleListStream()
            .map { [weak self] model -> [ArticleListTableCellModel] in
                guard let weakSelf = self else { return [] }
                weakSelf.dataSource += weakSelf.mapper.transform(model: model)
                return weakSelf.dataSource
            }
            .asSignal(onErrorJustReturn: [])
    }

    func updateArticleList(searchQuery: String, isAdditional: Bool) {
        if !isAdditional { dataSource = [] }
        usecase.updateArticleList(searchQuery: searchQuery, isAdditional: isAdditional)
    }
}