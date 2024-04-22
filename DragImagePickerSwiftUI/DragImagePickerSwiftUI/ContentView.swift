//
//  ContentView.swift
//  DragImagePickerSwiftUI
//
//  Created by 김정민 on 2023/09/11.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ImagePicker(
                    title: "Drag & Drop",
                    subTitle: "Tap to add an image",
                    systemImage: "square.and.arrow.up",
                    tint: .blue
                ) { image in
                        print("이미지: \(image)")
                }
                .frame(maxWidth: 300, maxHeight: 250)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Image Picker")
        }
    }
}

#Preview {
    ContentView()
}

/// Custom Image Picker
/// Included With Drag & Drop
struct ImagePicker: View {
    var title: String
    var subTitle: String
    var systemImage: String
    var tint: Color
    var onImageChange: (UIImage) -> ()
    
    /// View Properties
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    
    /// Preview Image
    @State private var previewImage: UIImage?
    
    /// Loading Status
    @State private var isLoading: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 4) {
                Image(systemName: self.systemImage)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(self.tint)
                
                Text(self.title)
                    .font(.callout)
                    .padding(.top, 15)
                
                Text(self.subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            /// Displaying Preview Image, if any
            .opacity(self.previewImage == nil ? 1 : 0)
            .frame(width: size.width, height: size.height)
            .overlay {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                }
            }
            /// Displaying Loading UI
            .overlay {
                if self.isLoading {
                    ProgressView()
                        .padding(10)
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
                }
            }
            /// Animating Changes
            .animation(.snappy, value: self.isLoading)
            .animation(.snappy, value: self.previewImage)
            .contentShape(.rect)
            /// Implementing Drop Action and Retreving Dropped Image
            .dropDestination(for: Data.self, action: { (items: [Data], location: CGPoint) in
                if let firstItem = items.first,
                   let droppedImage = UIImage(data: firstItem) {
                    /// Sending the Image using the callback
                    self.generateImageThumbnail(droppedImage, size)
                    self.onImageChange(droppedImage)
                    return true
                }
                return false
                
            }, isTargeted: { (isTargeted: Bool) in
                
            })
            .onTapGesture {
                self.showImagePicker.toggle()
            }
            /// Implement Manual Image Picker
            .photosPicker(isPresented: self.$showImagePicker, selection: self.$photoItem)
            /// Process the selected image
            .optionalViewModifier(content: { contentView in
                if #available(iOS 17, *) {
                    contentView
                        .onChange(of: self.photoItem) { oldValue, newValue in
                            if let newValue {
                                self.extractImage(newValue, viewSize: size)
                            }
                        }
                } else {
                    contentView
                        .onChange(of: self.photoItem) { newValue in
                            if let newValue {
                                self.extractImage(newValue, viewSize: size)
                            }
                        }
                }
            })
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(self.tint.opacity(0.08).gradient)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(self.tint, style: .init(lineWidth: 1, dash: [12]))
                        .padding(1)
                }
            }
        }
    }
    
    /// Extracting Image from PhotoItem
    func extractImage(_ photoItem: PhotosPickerItem, viewSize: CGSize) {
        Task.detached {
            guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else { return }
            
            /// UI Must be Updated on Main Thread
            await MainActor.run {
                if let selectedImage = UIImage(data: imageData) {
                    /// Creating Preview
                    self.generateImageThumbnail(selectedImage, viewSize)
                    /// Send Original Image to Callback
                    self.onImageChange(selectedImage)
                }
                
                /// Clearing PhotoItem
                self.photoItem = nil
            }
        }
    }
    
    /// Creating Image Thumbnail
    func generateImageThumbnail(_ image: UIImage, _ size: CGSize) {
        Task.detached {
            /*
             Video Time: (07:03 / 10:56)
             - As you can notice, by creating the thumbnail for preview,
             we can save a lot of memory. Also, you can notice that the callback returns the original image, not the resized one, so that the user can use the selected or dropped image for their purpose.
             */
            let thumbnailImage = await image.byPreparingThumbnail(ofSize: size)
            /// UI Must be Updated on Main Thread
            await MainActor.run {
                self.previewImage = thumbnailImage
            }
        }
    }
}

/// Custom Optional View Modifier
extension View {
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}
