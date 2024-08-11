//
//  SearchVC.swift
//  Netflix
//
//  Created by Mabast on 2024-08-03.
//

import UIKit

class SearchVC: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchBar: UISearchController = {
        let searchBar = UISearchController(searchResultsController: SearchResultsVC())
        searchBar.searchBar.placeholder = "Search for a Movie or a TV Show"
        searchBar.searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchBar
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(searchTable)
        searchTable.delegate = self
        searchTable.dataSource = self
        fetchSearchedResults()
        searchBar.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    func fetchSearchedResults() {
        APICaller.shared.getSearchResults { [weak self] result in
            switch result {
            case .success(let title):
                self?.titles = title
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: TitleViewModel(titleName: titles[indexPath.row].original_title ?? titles[indexPath.row].original_name ?? "Unkown", posterURL: titles[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        APICaller.shared.getMovieTrailer(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewVC()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeVideo: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchVC: UISearchResultsUpdating, SearchResultsVCDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar
        guard let text = searchText.text, !text.trimmingCharacters(in: .whitespaces).isEmpty, text.trimmingCharacters(in: .whitespaces).count >= 3, let resultsController = searchController.searchResultsController as? SearchResultsVC else { return }
        
        resultsController.delegate = self
        
            APICaller.shared.search(with: text) { result in
                DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultsVCDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
