//
//  ViewController.swift
//  DummyApp
//
//  Created by JeongminKim on 2023/05/02.
//

import UIKit
import EmailValidator

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let email = "abc.gmail.com"
        print("result: \(EmailValidator.isValidEmail(email: email))")
    }

}

