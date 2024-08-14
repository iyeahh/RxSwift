//
//  DetailViewController.swift
//  iTunesProject
//
//  Created by Bora Yang on 8/14/24.
//

import UIKit

class DetailViewController: UIViewController {

    var appTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        navigationItem.title = appTitle
    }
}
