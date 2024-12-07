//
//  BaseViewController.swift
//  ReactorKitMission
//
//  Created by 김정민 on 11/27/24.
//

import UIKit
import ReactorKit

final class BaseViewController: UIViewController, View {
    typealias Reactor = <#type#>
    
    var disposeBag: RxSwift.DisposeBag
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

