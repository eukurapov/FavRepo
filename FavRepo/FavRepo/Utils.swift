//
//  Utils.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import UIKit

var defaultBackground: UIColor {
    if #available(iOS 13, *) {
        return .systemBackground
    } else {
        return .white
    }
}
