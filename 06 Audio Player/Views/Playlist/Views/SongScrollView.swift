//
//  SongScrollView.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

class SongScrollView: UIScrollView {
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    var playingTrackNumber: Int? {
        didSet {
            if let number = playingTrackNumber,
               let songItemViews = stackView.arrangedSubviews as? [SongItemView] {
                for view in songItemViews where view.isPlaying {
                    view.isPlaying.toggle()
                }
                songItemViews[number].isPlaying.toggle()
            }
        }
    }
        
    // MARK: - initializers
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper initialization methods
    
    private func setupViews() {
        // set bottom inset for scrollView as height of playingNowView
        self.contentInset.bottom = AppConstants.playingNowHeight
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(H: "|[stackView]|", V: "|[stackView]|")
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    // MARK: - Configuration methods
    
    func reload(withSongs songs: [Song]) {
        // remove all subviews from stackView
        stackView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        // add new subviews
        for song in songs {
            let songView = SongItemView(withSong: song)
            stackView.addArrangedSubview(songView)
            songView.heightAnchor.constraint(equalToConstant: AppConstants.songItemHeight).isActive = true
        }
    }
}
