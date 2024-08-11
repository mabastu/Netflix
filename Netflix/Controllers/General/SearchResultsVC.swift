//
//  SearchResultsVC.swift
//  Netflix
//
//  Created by Mabast on 2024-08-09.
//

import UIKit

protocol SearchResultsVCDelegate: AnyObject {
    func searchResultsVCDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsVC: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultsVCDelegate?
    
    public let searchResultsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsView)
        
        searchResultsView.delegate = self
        searchResultsView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsView.frame = view.bounds
    }
}

extension SearchResultsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: titles[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let titleName = titles[indexPath.row].original_title ?? ""
        
        APICaller.shared.getMovieTrailer(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultsVCDidTapItem(TitlePreviewViewModel(title: titleName, youtubeVideo: videoElement, titleOverview: self?.titles[indexPath.row].overview ?? ""))
                case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
