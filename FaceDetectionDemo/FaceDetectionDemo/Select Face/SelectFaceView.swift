//
//  SelectFaceView.swift
//  FaceDetectionDemo
//
//  Created by ShinIl Heo on 10/14/25.
//

import SwiftUI
import PhotosUI

struct SelectFaceView: View {
    @State private var pickedItem: PhotosPickerItem?
    @State private var image: UIImage?
    
    var body: some View {
        VStack(spacing: 16) {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 260)
            }

            PhotosPicker(selection: $pickedItem,
                         matching: .images,
                         photoLibrary: .shared()) {
                Label("Select Image", systemImage: "photo")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.9))
                    .foregroundStyle(Color.white)
                    .clipShape(ButtonBorderShape.roundedRectangle)
            }
            .onChange(of: pickedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        image = uiImage
                    }
                }
             }
            
            if let image {
                Button {
                    print("Go button tapped")
                } label: {
                    Label("Process", systemImage: "gearshape.fill")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.9))
                        .foregroundStyle(Color.white)
                        .clipShape(ButtonBorderShape.roundedRectangle)
                }

            }
        }
        .padding()
    }
}

#Preview {
    SelectFaceView()
}
