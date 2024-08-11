//
//  SearchViewController.swift
//  iTunesProject
//
//  Created by Bora Yang on 8/11/24.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    private lazy var resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavi()
        bind()
    }

    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 20
        let width = UIScreen.main.bounds.width - 20
        layout.itemSize = CGSize(width: width, height: width * 0.8)
        return layout
    }

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(resultCollectionView)
        resultCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func configureNavi() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "검색"
    }
}

extension SearchViewController {
    private func bind() {

    }
}
