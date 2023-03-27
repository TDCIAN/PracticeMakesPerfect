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
    
    private lazy var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setPip()
    }
    
    private func setLayout() {
        [videoView, button].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            videoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            videoView.heightAnchor.constraint(equalToConstant: 250),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30.0),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 70),
        ])
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
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.delegate = self
    }
    
    @objc private func didTapButton() {
        guard let isActive = pipController?.isPictureInPictureActive else { return }
            isActive ? pipController?.stopPictureInPicture() : pipController?.startPictureInPicture()
            isActive ? button.setTitle("비활성화", for: .normal) : button.setTitle("활성화", for: .normal)
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
