//
//  CustomButton.swift
//  AnimatedButton
//
//  Created by 김정민 on 2023/09/12.
//

import SwiftUI

struct CustomButton<ButtonContent: View>: View {
    var buttonTint: Color = .white
    var content: () -> ButtonContent
    /// Button Action
    var action: () async -> TaskStatus
    /// View Properties
    @State private var isLoading: Bool = false // is used to show the progress indicator
    @State private var taskStatus: TaskStatus = .idle // is used to show an exclamatory or checkmark icon based on the action response
    @State private var isFailed: Bool = false
    @State private var wiggle: Bool = false
    /// Popup Properties
    @State private var showPopup: Bool = false // show the error or failure message in a popup manner
    @State private var popupMessage: String = "" // show the error or failure message in a popup manner
    
    var body: some View {
        Button(action: {
            /*
             Video Time: (03:43 / 10:57)
             As you can see, the button is disabled until the action is completed.
             This is done with Swift's Async/Await.
             */
            Task {
                self.isLoading = true
                let taskStatus = await action()
                switch taskStatus {
                case .idle:
                    self.isFailed = false
                case .failed(let message):
                    self.isFailed = true
                    self.popupMessage = message
                case .success:
                    self.isFailed = false
                }
                
                self.taskStatus = taskStatus
                if self.isFailed {
                    try? await Task.sleep(for: .seconds(0))
                    self.wiggle.toggle()
                }
                try? await Task.sleep(for: .seconds(0.8))
                if self.isFailed {
                    self.showPopup = true
                }
                self.taskStatus = .idle
                self.isLoading = false
            }
        }, label: {
            self.content()
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .opacity(self.isLoading ? 0 : 1)
                .lineLimit(1)
                .background {
                    GeometryReader {
                        let size = $0.size
                        let circleRadius = 50.0
                        
                        Capsule()
                            .fill(Color(self.taskStatus == .idle ? self.buttonTint : self.taskStatus == .success ? .green : .red).shadow(.drop(color: .black.opacity(0.15), radius: 6)))
                            .frame(width: isLoading ? circleRadius : nil, height: isLoading ? circleRadius : nil)
                            .frame(width: size.width, height: size.height, alignment: .center)
                    }
                }
                .overlay {
                    if self.isLoading && self.taskStatus == .idle {
                        ProgressView()
                    }
                }
                .overlay {
                    if self.taskStatus != .idle {
                        Image(systemName: self.isFailed ? "exclamationmark" : "checkmark")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                }
                .wiggle(self.wiggle)
        })
        .disabled(self.isLoading)
        .popover(isPresented: self.$showPopup, content: {
            Text(self.popupMessage)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .presentationCompactAdaptation(.popover)
        })
        .animation(.snappy, value: self.isLoading)
        .animation(.snappy, value: self.taskStatus)
    }
}

/// Custom Opacity Less Button Style
extension ButtonStyle where Self == OpacityLessButtonStyle {
    static var opacityLess: Self {
        Self()
    }
}

struct OpacityLessButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

/// Wiggle Extension
extension View {
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
                view
                    .offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    /*
                     Video Time: (07:26 / 10:57)
                     - As you can see, I'm simply moving the view between left and right by about 5 pixels to create a wiggle effect.
                     The total time it takes to complete the animation is 0.8s, and you've already noted that I've used this exact amount as the delay value in the action block.
                     */
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }


    }
}

enum TaskStatus: Equatable {
    case idle
    case failed(String)
    case success
}

#Preview {
    ContentView()
}
