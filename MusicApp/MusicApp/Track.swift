//
//  Track.swift
//  MusicApp
//
//  Created by JeongminKim on 2022/12/13.
//

import UIKit
import AVFoundation

class Track {
    var title: String
    var thumb: UIImage
    var artist: String
    
    init(title: String, thumb: UIImage, artist: String) {
        self.title = title
        self.thumb = thumb
        self.artist = artist
    }
    
    var asset: AVAsset {
        let path = Bundle.main.path(forResource: title, ofType: "mov")!
        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        return asset
    }
}
