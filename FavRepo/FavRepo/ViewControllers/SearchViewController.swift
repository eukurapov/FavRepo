//
//  ViewController.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var defaultRepos = ["first nice repo", "second repo", "my project", "qwertyPas", "FavRepo"]
    
    private var repos = [String]()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: repositoryCellIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        
        setupSearchcontroller()
        layout()
        
        repos = defaultRepos
        tableView.reloadData()
    }
    
    private func setupSearchcontroller() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repositories"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private let repositoryCellIdentifier = "Repository"

}

extension SearchViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           !searchText.isEmpty {
            repos = defaultRepos.filter { $0.lowercased().contains(searchText.lowercased()) }
            tableView.reloadData()
        } else {
            repos = defaultRepos
            tableView.reloadData()
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: repositoryCellIdentifier, for: indexPath)
        cell.textLabel?.text = repos[indexPath.row]
        return cell
    }
    
}
