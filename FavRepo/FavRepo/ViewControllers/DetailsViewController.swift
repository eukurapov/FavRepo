//
//  DetailsViewController.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var repository: Repository?
    
    private var descriptionLabel: UILabel = {
        let label = getUILabel(withTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    private var ownerTitleLabel: UILabel = getUILabel(withTextStyle: .headline, text: "Owner:")
    private var ownerLabel: UILabel = getUILabel(withTextStyle: .body)
    private var emailTitleLabel: UILabel = getUILabel(withTextStyle: .headline, text: "Email:")
    private var emailLabel: UILabel = getUILabel(withTextStyle: .body)
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = defaultBackground
        
        layout()
        
        let favoriteButton = UIButton()
        favoriteButton.setTitle("★", for: .normal)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize*1.5)
        favoriteButton.setTitleColor(.systemBlue, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        
        updateRepositoryDetails()
    }
    
    private func layout() {
        view.addSubview(descriptionLabel)
        view.addSubview(ownerTitleLabel)
        view.addSubview(ownerLabel)
        view.addSubview(emailTitleLabel)
        view.addSubview(emailLabel)
        view.addSubview(activityIndicator)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
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
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func updateRepositoryDetails() {
        if let repository = repository {
            title = repository.fullName
            descriptionLabel.text = repository.description
            activityIndicator.startAnimating()
            RepositoryService.shared.fetchDetailsForUserLogin(repository.owner.login) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    guard user.id == self.repository?.owner.id else { return }
                    self.repository?.owner = user
                    self.ownerLabel.text = user.name ?? user.login
                    self.emailLabel.text = user.email ?? "N/A"
                case .failure(let error):
                    print(error)
                }
                self.activityIndicator.stopAnimating()
            }
            updateFavoriteButton()
        }
    }
    
    @objc
    private func favorite() {
        repository?.toggleIsFavorite()
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton(animated: Bool = true) {
        if let favButton = navigationItem.rightBarButtonItem?.customView as? UIButton {
            UIView.transition(with: favButton, duration: animated ? 0.25 : 0, options: .transitionCrossDissolve) {
                favButton.setTitleColor((self.repository?.isFavorite ?? false) ? .systemYellow : .systemBlue, for: .normal)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFavoriteButton(animated: false)
    }
    
}
