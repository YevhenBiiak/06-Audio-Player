//
//  SongItemView.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

class SongItemView: UIView {
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let trackLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let playingNowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.fill")
        imageView.tintColor = UIColor.secondaryLabel
        imageView.isHidden = true
        return imageView
    }()
    
    var isPlaying: Bool = false {
        didSet {
            playingNowImage.isHidden = !isPlaying
        }
    }
    
    // MARK: - Initializers and overridden methods
    
    init(withSong song: Song) {
        super.init(frame: .zero)
        coverImage.image = song.cover ?? AppConstants.emptyCover
        trackLabel.text = song.track
        artistLabel.text = song.artist
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addBorder(at: .top, color: .systemGray4, width: 0.4, leftInset: 70)
        coverImage.layer.cornerRadius = 5
        coverImage.layer.masksToBounds = true
    }
    
    // MARK: - Helper initialization methods
    
    private func setupViews() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(coverImage)
        self.addSubview(trackLabel)
        self.addSubview(artistLabel)
        self.addSubview(playingNowImage)
    }
    
    private func setConstraints() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        playingNowImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(H: "|[coverImage(60)]", V: "|~[coverImage(60)]~|")
        self.addConstraints(H: "[coverImage]-8-[trackLabel]-8-|", V: "|-8-[trackLabel]")
        self.addConstraints(H: "[coverImage]-8-[artistLabel]-8-|", V: "[artistLabel]-8-|")
        self.addConstraints(H: "[playingNowImage]-16-|", V: "|~[playingNowImage]~|")
    }
}
