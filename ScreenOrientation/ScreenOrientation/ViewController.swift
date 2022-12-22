//
//  ViewController.swift
//  ScreenOrientation
//
//  Created by JeongminKim on 2022/12/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let portraitHeight: CGFloat = UIScreen.main.bounds.width * 0.5
    
    private var deviceOrientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    private lazy var screenView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var changeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapChangeButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLayout()
        setupNotification()
    }
    
    private func setLayout() {
        view.addSubview(screenView)
        screenView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.leading.equalTo(view.safeAreaInsets.left)
            $0.trailing.equalTo(view.safeAreaInsets.right)
            $0.height.equalTo(portraitHeight)
        }
        
        screenView.addSubview(changeButton)
        changeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.equalTo(65)
            $0.height.equalTo(45)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientaionChanged), name: UIDevice.orientationDidChangeNotification, object: UIDevice.current)
    }

    @objc private func didTapChangeButton() {
        print("탭탭")
    }
    
    @objc private func orientaionChanged(noti: NSNotification) {
        switch deviceOrientation {
        case .unknown:
            return
        case .portrait:
            print("셋 포트레이트 - \(deviceOrientation.description)")
        case .portraitUpsideDown:
            print("셋 포트레이트 - \(deviceOrientation.description) ")
        case .landscapeLeft:
            print("셋 랜드스케이프 레프트 - \(deviceOrientation.description)")
        case .landscapeRight:
            print("셋 랜드스케이프 라이트 - \(deviceOrientation.description)")
        case .faceUp:
            return
        case .faceDown:
            return
        @unknown default:
            return
        }
    }
}


extension UIDeviceOrientation {
    var description: String {
        switch self {
        case .unknown:
            return "언노운"
        case .portrait:
            return "포트레이트"
        case .portraitUpsideDown:
            return "포트레이트업사이드다운"
        case .landscapeLeft:
            return "랜드스케이프 레프트"
        case .landscapeRight:
            return "랜드스케이프 라이트"
        case .faceUp:
            return "페이스업"
        case .faceDown:
            return "페이스다운"
        @unknown default:
            return "언노운디폴트"
        }
    }
}
