//
//  DetailsViewController.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var repo: (name: String, description: String, owner: String, email: String)! {
        didSet {
            title = repo.name
            descriptionLabel.text = repo.description
            ownerLabel.text = repo.owner
            emailLabel.text = repo.email
        }
    }
    
    private var descriptionLabel: UILabel = {
        let label = getUILabel(withTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    private var ownerTitleLabel: UILabel = getUILabel(withTextStyle: .headline, text: "Owner:")
    private var ownerLabel: UILabel = getUILabel(withTextStyle: .body)
    private var emailTitleLabel: UILabel = getUILabel(withTextStyle: .headline, text: "Email:")
    private var emailLabel: UILabel = getUILabel(withTextStyle: .body)
    
    private var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = defaultBackground
        
        repo = (
            name: "Some repo",
            description: "Here is a text with some detials about this super project",
            owner: "Vasily Petrovich",
            email: "vasya@dev.net"
        )
        
        layout()
        
        let favoriteButton = UIButton()
        favoriteButton.setTitle("★", for: .normal)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize*1.5)
        favoriteButton.setTitleColor(isFavorite ? .systemYellow : .systemBlue, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
    
    private func layout() {
        view.addSubview(descriptionLabel)
        view.addSubview(ownerTitleLabel)
        view.addSubview(ownerLabel)
        view.addSubview(emailTitleLabel)
        view.addSubview(emailLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            descriptionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: descriptionLabel.trailingAnchor, multiplier: 1),
            
            ownerTitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: descriptionLabel.bottomAnchor, multiplier: 2),
            ownerTitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
            ownerLabel.centerYAnchor.constraint(equalTo: ownerTitleLabel.centerYAnchor),
            ownerLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: ownerTitleLabel.trailingAnchor, multiplier: 1),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: ownerLabel.trailingAnchor, multiplier: 1),
            
            emailTitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: ownerTitleLabel.bottomAnchor, multiplier: 2),
            emailTitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
            emailLabel.centerYAnchor.constraint(equalTo: emailTitleLabel.centerYAnchor),
            emailLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: emailTitleLabel.trailingAnchor, multiplier: 1),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: emailLabel.trailingAnchor, multiplier: 1),
        ])
    }
    
    @objc
    private func favorite() {
        isFavorite.toggle()
        if let favButton = navigationItem.rightBarButtonItem?.customView as? UIButton {
            UIView.transition(with: favButton, duration: 0.75, options: .transitionCrossDissolve) {
                favButton.setTitleColor(self.isFavorite ? .systemYellow : .systemBlue, for: .normal)
            }
        }
    }
    
}
