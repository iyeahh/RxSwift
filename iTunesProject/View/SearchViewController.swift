//
//  SearchViewController.swift
//  iTunesProject
//
//  Created by Bora Yang on 8/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class SearchViewController: UISearchController {
    private let resultTableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavi()
        bind()
    }

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        resultTableView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
    }

    private func configureNavi() {
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "검색"
    }
}

extension SearchViewController {
    private func bind() {
        let input = SearchViewModel.Input(
            searchButtonTap: searchController.searchBar.rx.searchButtonClicked,
            searchText: searchController.searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)

        output.appList
            .bind(to: resultTableView.rx.items(cellIdentifier: ResultTableViewCell.identifier, cellType: ResultTableViewCell.self)) { (row, element, cell) in
                cell.categoryLabel.text = element.genres.first
                cell.descriptionImageView1.kf.setImage(with: URL(string: element.screenshotUrls[0]))
                cell.descriptionImageView2.kf.setImage(with: URL(string: element.screenshotUrls[1]))
                cell.descriptionImageView3.kf.setImage(with: URL(string: element.screenshotUrls[2]))
                cell.companyLabel.text = element.sellerName
                cell.nameLabel.text = element.trackName
                let roundedDouble = round(element.averageUserRating)
                cell.rateLabel.text = "\(roundedDouble)"
                cell.iconImageView.kf.setImage(with: URL(string: element.artworkUrl100))
            }
            .disposed(by: disposeBag)
    }
}
