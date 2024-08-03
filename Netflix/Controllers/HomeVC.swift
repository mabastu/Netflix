//
//  HomeVC.swift
//  Netflix
//
//  Created by Mabast on 2024-08-03.
//

import UIKit

class HomeVC: UIViewController {
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Upcoming Movies", "Top Rated"]
    
    private let homeFeed: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(HomeCllectionViewCell.self, forCellReuseIdentifier: HomeCllectionViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeed)
        
        homeFeed.dataSource = self
        homeFeed.delegate = self
        
        homeFeed.tableHeaderView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        configureNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeed.frame = view.bounds
    }
    
    private func configureNavBar() {
        var netflixLogo = UIImage(resource: .netflixLogo)
        netflixLogo = netflixLogo.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: netflixLogo, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCllectionViewCell.identifier, for: indexPath) as? HomeCllectionViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//        
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
//    }
}
