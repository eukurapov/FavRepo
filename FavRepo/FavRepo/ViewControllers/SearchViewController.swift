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
    private lazy var placeholderView: LoadingView = {
        let view = LoadingView()
        view.message = "No Results"
        return view
    }()
    
    private var searchTimer: Timer?
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
      var recognizer = UITapGestureRecognizer(
        target:navigationItem.searchController?.searchBar,
        action: #selector(resignFirstResponder))
      return recognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        
        setupSearchcontroller()
        layout()
    }
    
    private func setupSearchcontroller() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repositories"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubview(placeholderView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func fetch() {
        let searchText = searchRequest?.query
        if searchRequest?.result.isEmpty ?? true {
            placeholderView.isHidden = false
            placeholderView.start()
            tableView.reloadData()
        }
        searchRequest?.fetch { [weak self, searchText] result in
            guard searchText == self?.searchRequest?.query else { return }
            switch result {
            case .success(_):
                self?.tableView.reloadData()
                self?.placeholderView.stop()
                self?.placeholderView.isHidden = true
            case .failure(let error):
                print(error)
                self?.placeholderView.stop()
                self?.placeholderView.message = "Could not perform request, please try again later"
            }
        }
    }
    
    // MARK: - Constant Values
    
    private let repositoryCellIdentifier: String = "Repository"
    private let searchDelay: TimeInterval = 0.75

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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      view.removeGestureRecognizer(tapRecognizer)
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

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false) { _ in
            if let searchText = searchController.searchBar.text,
               !searchText.isEmpty {
                self.searchRequest = SearchRequest(for: searchText)
                self.fetch()
            } else {
                self.searchRequest = nil
                self.tableView.reloadData()
                self.placeholderView.message = "No Results"
                self.placeholderView.isHidden = false
            }
        }
    }
    
}
