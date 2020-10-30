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

func getUILabel(withTextStyle style: UIFont.TextStyle, text: String? = nil) -> UILabel {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: style)
    label.adjustsFontForContentSizeCategory = true
    label.text = text
    return label
}
