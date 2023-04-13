//
//  MainVC.swift
//  TodoAppTutorial
//
//  Created by JeongminKim on 2023/04/13.
//

import UIKit
import SwiftUI

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        self.view.backgroundColor = .systemYellow
    }
}

extension MainVC {
    private struct VCRepresentable: UIViewControllerRepresentable {
        
        let mainVC: MainVC
        
        func updateUIViewController(
            _ uiViewController: UIViewControllerType,
            context: Context
        ) {
            
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return mainVC
        }
    }
    
    func getRepresentable() -> some View {
        VCRepresentable(mainVC: self)
    }
}

protocol StoryBoarded {
    static func instantiate(_ storyboardName: String?) -> Self
}

extension MainVC: StoryBoarded {
    static func instantiate(_ storyboardName: String? = nil) -> Self {
        let name = storyboardName ?? String(describing: self)
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(
            withIdentifier: String(describing: self)
        ) as! Self
    }
}
