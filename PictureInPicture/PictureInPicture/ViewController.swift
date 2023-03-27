//
//  ViewController.swift
//  PictureInPicture
//
//  Created by JeongminKim on 2023/03/27.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    private lazy var playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("PLAY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    var pip: AVPictureInPictureController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupCustomPlayer()
    }
    
    private func setLayout() {
        [playerView, button].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            playerView.heightAnchor.constraint(equalToConstant: 250),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30.0),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 70),
        ])
    }

    private func setupCustomPlayer() {
        guard let url = URL(string: "https://video-ssl.itunes.apple.com/itunes-assets/Video113/v4/5a/d8/ba/5ad8ba89-a4a4-6d49-fc2c-088ff28c634c/mzvf_9390810281620080323.640x480.h264lc.U.p.m4v") else { return }
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.playerView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerView.layer.addSublayer(playerLayer)
        pip = AVPictureInPictureController(playerLayer: playerLayer)
    }
    
    @objc private func didTapButton() {
        guard let url = URL(string: "https://video-ssl.itunes.apple.com/itunes-assets/Video113/v4/5a/d8/ba/5ad8ba89-a4a4-6d49-fc2c-088ff28c634c/mzvf_9390810281620080323.640x480.h264lc.U.p.m4v") else { return }
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }

}

