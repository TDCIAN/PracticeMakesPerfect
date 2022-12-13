//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by JeongminKim on 2022/12/13.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationTimeLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    var track: Track?
    var avPlayer: AVPlayer?
    var timeObserver: Any?
    
    var currentTime: Double {
        return avPlayer?.currentItem?.currentTime().seconds ?? 0
    }
    
    var totalDurationTime: Double {
        return avPlayer?.currentItem?.duration.seconds ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        prepareToPlay()
        
        // timescale을 10으로 한 것은 1초를 10개로 쪼갠 것임
        timeObserver = avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 10), queue: DispatchQueue.main) { item in // 0.1초, 0.2초처럼 시간이 계속 넘어온다
            self.updateTime(time: item)
        }
    }
    
    func updateUI() {
        guard let currentTrack = track else { return }
        thumbnail.image = currentTrack.thumb
        trackTitle.text = currentTrack.title
        artistName.text = currentTrack.artist
        playPauseButton.setImage(UIImage(named: "icPlay"), for: .normal)
    }
    
    func prepareToPlay() {
        guard let currentTrack = track else { return }
        let asset = currentTrack.asset
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        avPlayer = player
    }
    
    func updateTime(time: CMTime) {
        print("CMTime: \(time.seconds)")
        // currentTime label, totalDuration label, slider
        currentTimeLabel.text = secondsToString(sec: currentTime)
        totalDurationTimeLabel.text = secondsToString(sec: totalDurationTime)
        
        if isSeeking == false {
            timeSlider.value = Float(currentTime/totalDurationTime)
        }
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    func play() {
        avPlayer?.play()
    }
    
    func pause() {
        avPlayer?.pause()
    }
    
    func seek(to: Double) {
        let timeScale: CMTimeScale = 10
        let targetTime: CMTimeValue = CMTimeValue(to * totalDurationTime) * CMTimeValue(timeScale)
        let time = CMTime(value: targetTime, timescale: timeScale)
        avPlayer?.seek(to: time)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let isPlaying = avPlayer?.rate == 1
        
        if isPlaying {
            pause()
            playPauseButton.setImage(UIImage(named: "icPlay"), for: .normal)
        } else {
            play()
            playPauseButton.setImage(UIImage(named: "icPause"), for: .normal)
        }
    }
    var isSeeking = false
    @IBAction func dragging(_ sender: UISlider) {
        isSeeking = true
    }
    
    @IBAction func endDragging(_ sender: UISlider) {
        isSeeking = false
        seek(to: Double(sender.value))
    }
    
    @IBAction func close() {
        pause()
        avPlayer?.replaceCurrentItem(with: nil)
        avPlayer = nil
        
        dismiss(animated: true, completion: nil)
    }
}
