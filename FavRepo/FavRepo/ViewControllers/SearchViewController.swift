//
//  ViewController.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var repos = ["first nice repo", "second repo", "my project", "qwertyPas", "FavRepo"]
    
    private var searchResult = [String]()
    private lazy var resultsTable: UITableView = {
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
        
        searchResult = repos
        resultsTable.reloadData()
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
        view.addSubview(resultsTable)
        resultsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            resultsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            resultsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private let repositoryCellIdentifier = "Repository"

}

extension SearchViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           !searchText.isEmpty {
            searchResult = repos.filter { $0.lowercased().contains(searchText.lowercased()) }
            resultsTable.reloadData()
        } else {
            searchResult = repos
            resultsTable.reloadData()
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: repositoryCellIdentifier, for: indexPath)
        cell.textLabel?.text = searchResult[indexPath.row]
        return cell
    }
    
}
