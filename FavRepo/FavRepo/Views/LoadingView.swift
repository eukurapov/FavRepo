//
//  LoadingView.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 02.11.2020.
//

import UIKit

class LoadingView: UIView {
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    private var messageLabel: UILabel = getUILabel(withTextStyle: .caption1)
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = defaultBackground
        layout()
    }
    
    func layout() {
        addSubview(messageLabel)
        addSubview(activityIndicator)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func start() {
        activityIndicator.startAnimating()
        messageLabel.isHidden = true
    }
    
    func stop() {
        activityIndicator.stopAnimating()
        messageLabel.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
