//
//  ViewController.swift
//  WebView
//
//  Created by JeongminKim on 2023/01/31.
//

import UIKit
import WebKit

protocol WebViewDelegate: AnyObject {
    
}

class ViewController: BaseViewController {
    weak var delegate: WebViewDelegate?
    var url: URL = URL(string: "https://tdcian.tistory.com/")!
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        addBottomToolBar()
        loadWebPage()
    }
    
    private func setLayout() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func loadWebPage() {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    override func didTapToolBarBackButton() {
        webView.goBack()
    }
    
    override func didTapToolBarForwardButton() {
        webView.goForward()
    }
}

extension ViewController: WKNavigationDelegate {
    // WKWebView에서 다른곳으로 이동할 때마다 호출되는 메소드(didFinish와 짝꿍)
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit - show loading indicator")
        // didFinish에 하지 않고 didCommit에 해야 페이지에 들어가면서 자연스럽게 활성화
        barBackButtonItem.isEnabled = webView.canGoBack
        barForwardButtonItem.isEnabled = webView.canGoForward
    }
    
    // WKWebView에서 다른곳으로 이동된 후에 호출되는 메소드(didCommit과 짝꿍)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish - hide loading indicator")
    }
}
