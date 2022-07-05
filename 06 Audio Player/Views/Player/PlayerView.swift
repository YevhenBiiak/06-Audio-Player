//
//  PlayerView.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

class PlayerView: UIView {
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.image = AppConstants.defaultArtwork
        return imageView
    }()
    
    private let songLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
