//
//  ViewController.swift
//  SubscribeSample
//
//  Created by 김정민 on 3/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just("Tell me something~")
            .subscribe { (string: Event<String>) in
                print(string.element)
            }
            .disposed(by: self.disposeBag)
        
        Observable.just("Tell me something!")
            .subscribe(onNext: { (string: String) in
                print(string)
            })
            .disposed(by: self.disposeBag)
    }


}

