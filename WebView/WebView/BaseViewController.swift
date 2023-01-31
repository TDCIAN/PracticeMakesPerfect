//
//  BaseViewController.swift
//  WebView
//
//  Created by JeongminKim on 2023/01/31.
//

import UIKit

class BaseViewController: UIViewController {
    
    private lazy var backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    lazy var barBackButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapToolBarBackButton))
    }()
    
    lazy var barForwardButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(didTapToolBarForwardButton))
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if navigationController?.viewControllers.first == self {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }
    
    @objc func didTapBackButton() {print("BaseViewController - didTapBackButton()")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapCloseButton() {
        print("BaseViewController - didTapCloseButton()")
        dismiss(animated: true, completion: nil)
    }
    
    func showBackButton(isHide: Bool) {
        backButton.isHidden = isHide
        closeButton.isHidden = isHide
    }
    
    // MARK: - UIToolBar
    func addBottomToolBar() {
        let paddingButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        paddingButtonItem.width = 24.0
        toolbarItems = [barBackButtonItem, paddingButtonItem, barForwardButtonItem]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func didTapToolBarBackButton() {
        
    }
    
    @objc func didTapToolBarForwardButton() {
        
    }
}
