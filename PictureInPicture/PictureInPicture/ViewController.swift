//
//  ViewController.swift
//  PictureInPicture
//
//  Created by JeongminKim on 2023/03/27.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    private let playerLayer = AVPlayerLayer()
    private let player = AVPlayer()
    private var pipController: AVPictureInPictureController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPip()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    private func setPip() {
        guard let url = URL(string: "https://video-ssl.itunes.apple.com/itunes-assets/Video113/v4/5a/d8/ba/5ad8ba89-a4a4-6d49-fc2c-088ff28c634c/mzvf_9390810281620080323.640x480.h264lc.U.p.m4v") else { return }
        
        let asset = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: asset)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
        player.play()
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(playerLayer: playerLayer)
            pipController?.delegate = self
        } else {
            print("Picture in picture is not supported")
        }
    }
}

extension ViewController: AVPictureInPictureControllerDelegate {
  func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    print("willStart")
  }
  func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    print("didStart")
  }
  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
    print("error")
  }
  func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    print("willStop")
  }
  func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    print("didStop")
  }
  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
    print("restore")
  }
}
