//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by Bora Yang on 8/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {

    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()

    let viewModel = BoxOfficeViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }

    func createObservable() {
        let random = Observable<Int>.create { value in
            let result = Int.random(in: 1...100)
            if result >= 1 && result <= 45 {
                value.onNext(result)
            } else {
                value.onCompleted()
            }
            return Disposables.create()
        }

        random
            .subscribe(with: self) { owner, value in
                print("random: \(value)")
            } onCompleted: { value in
                print("completed")
            } onDisposed: { value in
                print("disposed")
            }
            .disposed(by: disposeBag)
    }

    func bind() {
        let recentText = PublishSubject<String>()

        let input = BoxOfficeViewModel.Input(
            searchButtonTap: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty,
            recentText: recentText)
        let output = viewModel.transform(input: input)

        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = element.movieNm
                cell.downloadButton.setTitle(element.openDt, for: .normal)
            }
            .disposed(by: disposeBag)

        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { (row, element, cell) in
                cell.label.text = "\(element), \(row)"
            }
            .disposed(by: disposeBag)

        Observable.zip(tableView.rx.modelSelected(String.self), tableView.rx.itemSelected)
            .map { "검색어는 \($0.0)" }
            .subscribe(with: self) { owner, value in
                recentText.onNext(value)
            }
            .disposed(by: disposeBag)
    }

    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)

        navigationItem.titleView = searchBar

        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }

        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
