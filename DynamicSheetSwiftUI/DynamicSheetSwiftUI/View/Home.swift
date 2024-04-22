//
//  Home.swift
//  DynamicSheetSwiftUI
//
//  Created by 김정민 on 2023/09/18.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var showSheet: Bool = false
    @State private var emailAddress: String = ""
    @State private var alreadyHavingAccount: Bool = false
    @State private var password: String = ""
    @State private var sheetHeight: CGFloat = .zero
    /// View's Height (Storing For Swipe Calculation)
    @State private var sheetFirstPageHeight: CGFloat = .zero
    @State private var sheetSecondPageHeight: CGFloat = .zero
    @State private var sheetScrollProgress: CGFloat = .zero
    /// Other Properties
    @State private var isKeyboardShowing: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                self.showSheet.toggle()
            }, label: {
                Text("Show Sheet")
            })
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding(30)
        /// Sheet
        .sheet(isPresented: self.$showSheet, onDismiss: {
            /// Resetting Properties
            self.sheetHeight = .zero
            self.sheetFirstPageHeight = .zero
            self.sheetSecondPageHeight = .zero
            self.sheetScrollProgress = .zero
        }, content: {
            /// Sheet View
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                ScrollViewReader(content: { proxy in
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 0) {
                            OnBoarding(size)
                                .id("First Page")
                            
                            LoginView(size)
                                .id("Second Page")
                        }
                        /// For Paging Needs to be Enabled
                        .scrollTargetLayout()
                    }
                    /// Enabling Paging ScrollView
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    /// Disabling ScrollView when Keyboard is Visible
                    .scrollDisabled(self.isKeyboardShowing)
                    /// Custom Button Which will be Updated over scroll
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            if self.sheetScrollProgress < 1 {
                                /// Continue Button
                                /// Moving to the Next Page (Using ScrollView Reader)
                                withAnimation(.snappy) {
                                    proxy.scrollTo("Second Page", anchor: .leading)
                                }
                            } else {
                                /// Get Started Button
                                
                            }
                        }, label: {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .opacity(1 - self.sheetScrollProgress)
                                /// Adding Some Extra Width for Second Page
                                .frame(width: 120 + (self.sheetScrollProgress * (self.alreadyHavingAccount ? 0 : 50)))
                                .overlay {
                                    /// Next Page Text
                                    HStack(spacing: 8) {
                                        Text(self.alreadyHavingAccount ? "Login" : "Get Started")
                                        
                                        Image(systemName: "arrow.right")
                                    }
                                    .fontWeight(.semibold)
                                    .opacity(self.sheetScrollProgress)
                                }
                                .padding(.vertical, 12)
                                .foregroundStyle(.white)
                                .background(.linearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), in: .capsule)
                        })
                        .padding(15)
                        .offset(y: self.sheetHeight - 100)
                        /// Moving Button Near to the Next View
                        .offset(y: self.sheetScrollProgress * -120)
                    }
                })
            
            })
            /// Presentation Customization
            .presentationCornerRadius(30)
            /// Presentation Detents
            .presentationDetents(self.sheetHeight == .zero ? [.medium] : [.height(self.sheetHeight)])
            /// Disabling Swipe to Dismiss
            .interactiveDismissDisabled()
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                self.isKeyboardShowing = true
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                self.isKeyboardShowing = false
            })
        })
    }
    
    /// First View (Onboarding)
    @ViewBuilder
    func OnBoarding(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Know Everything\nabout the weather")
                .font(.largeTitle.bold())
                .lineLimit(2)
            
            /// Custom Attributed SubTitle
            Text(self.attributedSubTitle)
                .font(.callout)
                .foregroundStyle(.gray)
        }
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 130)
        .frame(width: size.width, alignment: .leading)
        /// Finding the View's Height
        .heightChangePreference { height in
            self.sheetFirstPageHeight = height
            /// Since the Sheet Height will be same as the First/Initial Page Height
            self.sheetHeight = height
        }
    }
    
    var attributedSubTitle: AttributedString {
        let string = "Start now and learn more about local weather instantly"
        var attString = AttributedString(stringLiteral: string)
        if let range = attString.range(of: "local weather") {
            attString[range].foregroundColor = .black
            attString[range].font = .callout.bold()
        }
        return attString
    }
    
    /// Second View (Login/Signup View)
    @ViewBuilder
    func LoginView(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(self.alreadyHavingAccount ? "Login" : "Create an Account")
                .font(.largeTitle.bold())
            
            /// Custom TextField
            CustomTextField(hint: "Email Address", text: self.$emailAddress, icon: "envelope")
                .padding(.top, 20)
            
            CustomTextField(hint: "******", text: self.$password, icon: "lock", isPassword: true)
                .padding(.top, 20)
        }
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 220)
        .overlay(alignment: .bottom) {
            /// Other Login/Signup Views
            VStack(spacing: 15) {
                Group {
                    if self.alreadyHavingAccount {
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundStyle(.gray)
                            
                            Button(action: {
                                withAnimation(.snappy) {
                                    self.alreadyHavingAccount.toggle()
                                }
                            }, label: {
                                Text("Create an account")
                            })
                            .tint(.red)
                        }
                        .transition(.push(from: .bottom))
                    } else {
                        HStack(spacing: 4) {
                            Text("Already having an account?")
                                .foregroundStyle(.gray)
                            
                            Button(action: {
                                withAnimation(.snappy) {
                                    self.alreadyHavingAccount.toggle()
                                }
                            }, label: {
                                Text("Login")
                            })
                            .tint(.red)
                        }
                        .transition(.push(from: .top))
                    }
                }
                .font(.callout)
                .textScale(.secondary)
                .padding(.bottom, self.alreadyHavingAccount ? 0 : 15)
                
                if !self.alreadyHavingAccount {
                    /// Markup Text
                    Text("By signing up, you're agreeing to our **[Terms & Condition](https://apple.com)** and **[Privacy Policy](https://apple.com)**")
                        .font(.caption)
                        /// Markup Content will be Red
                        .tint(.red)
                        /// Others will be Gray
                        .foregroundStyle(.gray)
                        .transition(.offset(y: 100))
                }
            }
        }
        .frame(width: size.width)
        /// Finding the View's Height
        .heightChangePreference { height in
            self.sheetSecondPageHeight = height
            /// Just in Case, if the Second Page Height is Changed
            let diff = self.sheetSecondPageHeight - self.sheetFirstPageHeight
            self.sheetHeight = self.sheetFirstPageHeight + (diff * self.sheetScrollProgress)
        }
        /// Offset Preference
        .minXChangePreference { minX in
            let diff = self.sheetSecondPageHeight - self.sheetFirstPageHeight
            /// Truncating MinX between (0 to Screen Width)
            let truncatedMinX = min(size.width - minX, size.width)
            /*
             Video Time: (10:04 / 20:00)
             - So here's what I'm going to do, which is pretty straightforward:
             First, I'm going to calculate the difference between the first view and second view heght, then I'm going to convert the offset between 0 and screen width (since the second view will eventually start from screen width and come towards zero, I'll just reverse it, so it will be easier to convert this into a progress range of 0 to 1), and finally, with the calculated progress, I'm going to add the differnce height to the sheet.
             */
            /// Converting MinX to Progress (0 - 1)
            let progress = truncatedMinX / size.width
            self.sheetScrollProgress = progress
            /// Adding the Diffrence Height to the Sheet Height
            self.sheetHeight = self.sheetFirstPageHeight + (diff * progress)
        }
    }
}

#Preview {
    ContentView()
}

/// Custom TextField
struct CustomTextField: View {
    var hint: String
    @Binding var text: String
    var icon: String
    var isPassword: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if self.isPassword {
                SecureField(self.hint, text: self.$text)
            } else {
                TextField(self.hint, text: self.$text)
            }
            
            Divider()
        }
        .overlay(alignment: .trailing) {
            Image(systemName: self.icon)
                .foregroundStyle(.gray)
        }
    }
}
