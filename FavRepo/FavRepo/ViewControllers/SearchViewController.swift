//
//  ViewController.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var searchRequest: SearchRequest?
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: repositoryCellIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        
        setupSearchcontroller()
        layout()
    }
    
    private func setupSearchcontroller() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
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
    
    func fetch() {
        let searchText = searchRequest?.query
        searchRequest?.fetch { [weak self, searchText] result in
            guard searchText == self?.searchRequest?.query else { return }
            switch result {
            case .success(_):
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private let repositoryCellIdentifier = "Repository"

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text,
           !searchText.isEmpty {
            searchRequest = SearchRequest(for: searchText)
            fetch()
        } else {
            searchRequest = nil
            tableView.reloadData()
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchRequest = searchRequest {
            return searchRequest.isFullyLoaded ? searchRequest.result.count : searchRequest.result.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: repositoryCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        if isLoadingCell(for: indexPath) {
            cell.textLabel?.text = "Loading …"
        } else {
            cell.textLabel?.text = searchRequest?.result[indexPath.row].fullName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isLoadingCell(for: indexPath) else { return }
        let vc = DetailsViewController()
        vc.repository = searchRequest?.result[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            fetch()
        }
    }
    
}

private extension SearchViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= (searchRequest?.result.count ?? 0)
    }
    
}
