//
//  FrameworkListViewModel.swift
//  AppleFramework
//
//  Created by JeongminKim on 2022/11/22.
//

import Foundation
import Combine

final class FrameworkListViewModel {
    init(items: [AppleFramework], selectedItem: AppleFramework? = nil) {
        self.items = CurrentValueSubject(items)
        self.selectedItem = CurrentValueSubject(selectedItem)
    }
    
    // Data => Output
    let items: CurrentValueSubject<[AppleFramework], Never>
    let selectedItem: CurrentValueSubject<AppleFramework?, Never>
    
    // User Action => Input
    func didSelect(at indexPath: IndexPath) {
        let item = items.value[indexPath.item]
        print("디드셀렉트 - 아이템: \(item)")
        selectedItem.send(item)
    }
}
