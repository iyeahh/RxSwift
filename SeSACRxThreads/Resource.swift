//
//  Resource.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/11/01.
//

import UIKit

enum Color {
    static let black: UIColor = .textPoint
    static let white: UIColor = .viewPoint
}

extension String {
   var isNumber: Bool {
   do {
      let regex = try NSRegularExpression(pattern: "^[0-9]+$", options: .caseInsensitive)
      if let _ = regex.firstMatch(in: self, options: .reportCompletion, range: NSMakeRange(0, count)) { return true }
      } catch { return false }
      return false
   }
}
