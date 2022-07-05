//
//  Song.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit
import MediaPlayer

class Song {
    lazy var title: String? = getValue(byKey: .commonKeyTitle) as? String
    
    lazy var artist: String? = getValue(byKey: .commonKeyArtist) as? String
    
    lazy var artwork: UIImage? = {
        if let data = getValue(byKey: .commonKeyArtwork) as? Data {
            return UIImage(data: data)
        } else { return nil }
    }()
    
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    private func getValue(byKey key: AVMetadataKey) -> (NSCopying & NSObjectProtocol)? {
        let asset = AVAsset(url: url)
        let metadata = asset.commonMetadata
        let metadataItem = metadata.first { $0.commonKey == key }
        return metadataItem?.stringValue == "" ? nil : metadataItem?.value
    }
}
