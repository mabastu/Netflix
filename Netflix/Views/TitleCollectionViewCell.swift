//
//  TitleCollectionViewCell.swift
//  Netflix
//
//  Created by Mabast on 10/08/2023.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadImagesFromAPI(for image: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(image)") else { return }
        posterImageView.sd_setImage(with: url)
    }
}
