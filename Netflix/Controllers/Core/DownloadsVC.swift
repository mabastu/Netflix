//
//  DownloadsVC.swift
//  Netflix
//
//  Created by Mabast on 2024-08-03.
//

import UIKit

class DownloadsVC: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        view.addSubview(downloadTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadTable.delegate = self
        downloadTable.dataSource = self
        fetchFromLocalStorageToDownloads()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchFromLocalStorageToDownloads()
        }
    }
    
    private func fetchFromLocalStorageToDownloads() {
        DataPersistenceManager.shared.fetchAllTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                self?.downloadTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
}

extension DownloadsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: TitleViewModel(titleName: (titles[indexPath.row].original_title ?? titles[indexPath.row].original_name) ?? "Unkown", posterURL: titles[indexPath.row].poster_path ?? "Unkown"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { result in
                switch result {
                case .success:
                    self.titles.remove(at: indexPath.row)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
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
