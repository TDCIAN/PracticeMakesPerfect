//
//  FrameworkDetailViewModel.swift
//  AppleFramework
//
//  Created by JeongminKim on 2022/11/22.
//

import Foundation
import Combine

final class FrameworkDetailViewModel {
    
    init(framework: AppleFramework) {
        self.framework = CurrentValueSubject(framework)
    }
    
    // Data => Output
    let framework: CurrentValueSubject<AppleFramework, Never>
    
    // User Action => Input
    let buttonTapped = PassthroughSubject<AppleFramework, Never>()
    
    
    func learnMoreTapped() {
        buttonTapped.send(framework.value)
    }
    
}
