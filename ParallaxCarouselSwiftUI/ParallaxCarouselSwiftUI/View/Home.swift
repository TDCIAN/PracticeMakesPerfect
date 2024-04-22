//
//  Home.swift
//  ParallaxCarouselSwiftUI
//
//  Created by 김정민 on 2023/09/13.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var searchText: String = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                HStack(spacing: 12) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundStyle(.blue)
                    })
                    
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                        
                        TextField("Search", text: self.$searchText)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: .capsule)
                }
                
                Text("Which puppy do you want to live together?")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                
                
                /// Parallax Carousel
                GeometryReader(content: { geometry in
                    let size = geometry.size
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 5) {
                            ForEach(cards) { card in
                                /// In order to Move the Card  in Reverse Direction (Parallax Effect)
                                GeometryReader(content: { proxy in
                                    let cardSize = proxy.size
                                    // Simple Parallax Effect 1
//                                    let minX = proxy.frame(in: .scrollView).minX - 30.0
                                    // Simple Parallax Effect 2
                                    let minX = min((proxy.frame(in: .scrollView).minX * 1.4), proxy.size.width * 1.4)
                                    /*
                                     Video Time: (06:06 / 09:16)
                                     - So what I'm going to do here is simple. In the pase, I've moved exactly the same amount of minX in the reverse direction, which leads to Effect 2.
                                     I order to achieve Effect 1, I'm simply going to speed up the minX in the reverse direction, which may lead to an empty view while scrolling.
                                     To avoid that, I'm also going to increase the image size horizontally.
                                     
                                     NOTE: If Effect 2 also leads to an empty view if the given image is small, use the same technique. (Increase the width of the image slightly.)
                                     */
                                    
                                    Image(card.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        /// Or you can simply use scaling
                                        .scaleEffect(1.25)
                                        .offset(x: -minX)
//                                        .frame(width: proxy.size.width * 2.5)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay {
                                            ZStack {
                                                OverlayView(card: card)
                                                
                                                // Test change in minX
                                                Text("\(minX)")
                                                    .font(.largeTitle)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                })
                                .frame(width: size.width - 60, height: size.height - 50)
                                /*
                                 Video Time: (03:46 / 09:16)
                                 - Since I've applied horizontal pading of 30,
                                 which means 60, which is why I've reduced 60 from the card width.
                                 */
                                /// Scroll Animation
                                .scrollTransition(.interactive, axis: .horizontal) { (view: EmptyVisualEffect, phase: ScrollTransitionPhase) in
                                    view
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .scrollTargetLayout()
                        .frame(height: size.height, alignment: .top)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                })
                .frame(height: 500)
                .padding(.horizontal, -15)
                .padding(.top, 10)
            }
            .padding(15)
        }
        .scrollIndicators(.hidden)
    }
    
    /// Overlay View
    @ViewBuilder
    func OverlayView(card: Card) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(
                colors: [
                    .clear,
                    .clear,
                    .clear,
                    .clear,
                    .clear,
                    .black.opacity(0.1),
                    .black.opacity(0.5),
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text(card.subTitle)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        })
    }
}

#Preview {
    ContentView()
}
