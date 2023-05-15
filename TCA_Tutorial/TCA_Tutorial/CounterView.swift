//
//  CounterView.swift
//  TCA_Tutorial
//
//  Created by JeongminKim on 2023/05/13.
//

import SwiftUI
import ComposableArchitecture

// 도메인 + 상태
struct CounterState: Equatable {
    var count = 0
}

// 도메인 + 액션
enum CounterAction: Equatable {
    case addCount
    case subtractCount
}

struct CounterEnvironment {
    
}

let counterReducer = AnyReducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
 
    switch action {
    case .addCount:
        state.count += 1
        return EffectTask.none
    case .subtractCount:
        state.count -= 1
        return EffectTask.none
    }
}

struct CounterView: View {
    
    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {

                Text("카운트: \(viewStore.state.count)")
                HStack {
                    Button {
                        print("더하기 버튼")
                        viewStore.send(.addCount)
                    } label: {
                        Text("더하기")
                    }

                    Button {
                        print("빼기 버튼")
                        viewStore.send(.subtractCount)
                    } label: {
                        Text("빼기")
                    }
                }
            }
            .padding()
        }
        
    }
}
