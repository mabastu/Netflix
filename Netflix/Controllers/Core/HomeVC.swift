//
//  HomeVC.swift
//  Netflix
//
//  Created by Mabast on 2024-08-03.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTVs = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRated = 4
}

class HomeVC: UIViewController {
    
    private var randomTrendingMovies: Titles?
    private var headerView: HeroHeaderView?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeed: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(HomeCollectionViewCell.self, forCellReuseIdentifier: HomeCollectionViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeed)
        
        homeFeed.dataSource = self
        homeFeed.delegate = self
        
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeed.tableHeaderView = headerView
        configureNavBar()
        configureHeroHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeed.frame = view.bounds
    }
    
    func configureHeroHeaderView() {
        APICaller.shared.getTrendings(for: "movie") { [weak self] result in
            switch result {
            case .success(let titles):
                self?.randomTrendingMovies = titles.randomElement()
                self?.headerView?.configure(with: TitleViewModel(titleName: titles.randomElement()?.original_title ?? "", posterURL: titles.randomElement()?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendings(for: "movie") { result in
                switch result {
                case.success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTVs.rawValue:
            APICaller.shared.getTrendings(for: "tv") { result in
                switch result {
                case.success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getData(for: "popular"){ result in
                switch result {
                case.success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getData(for: "upcoming"){ result in
                switch result {
                case.success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getData(for: "top_rated"){ result in
                switch result {
                case.success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let defaultOffset = view.safeAreaInsets.top
    //        let offset = scrollView.contentOffset.y + defaultOffset
    //
    //        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
    //    }
}

extension HomeVC: HomeCllectionViewCellDelegate {
    func homeCllectionViewCellDidTap(_ cell: HomeCollectionViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
