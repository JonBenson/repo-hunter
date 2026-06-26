//
//  ViewController.swift
//  Repo Hunter
//
//  Created by John Benson on 19/06/2026.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = ViewModel(repoService: RepoService(networkClient: NetworkClient()))
    private var cancellables = Set<AnyCancellable>()
    private let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        bindViewModel()
    }
    
    
    private func bindViewModel() {
        viewModel.$repos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositories in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}

// MARK: - Tabel Data Source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let repo = viewModel.repos[indexPath.row]
            cell.textLabel?.text = repo.name
        
        return cell
    }
}

// MARK: - Tabel Delegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = 5
        
        if indexPath.row == (viewModel.repos.count - threshold) {
            Task{
                await viewModel.loadNextPage()
            }
        }
    }
}
