//
//  HomeCollectionViewCell.swift
//  Netflix
//
//  Created by Mabast on 2024-08-03.
//

import UIKit

protocol HomeCllectionViewCellDelegate: AnyObject {
    func homeCllectionViewCellDidTap(_ cell: HomeCollectionViewCell, viewModel : TitlePreviewViewModel)
}

class HomeCollectionViewCell: UITableViewCell {
    
    static let identifier = "HomeCllectionViewCell"
    
    private var titles: [Titles] = [Titles]()
    
    weak var delegate: HomeCllectionViewCellDelegate?
                         
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Titles]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension HomeCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let titleName = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name else {
            return
        }
        APICaller.shared.getMovieTrailer(with: titleName + " trailer") { result in
            switch result {
            case .success(let videoElement):
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeVideo: videoElement, titleOverview: self.titles[indexPath.row].overview ?? "")
                self.delegate?.homeCllectionViewCellDidTap(self, viewModel: viewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}
