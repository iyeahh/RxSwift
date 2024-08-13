//
//  BaseViewModel.swift
//  iTunesProject
//
//  Created by Bora Yang on 8/14/24.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
