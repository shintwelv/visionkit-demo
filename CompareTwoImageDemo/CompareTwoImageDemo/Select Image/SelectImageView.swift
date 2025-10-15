//
//  SelectImageView.swift
//  CompareTwoImageDemo
//
//  Created by ShinIl Heo on 10/15/25.
//

import SwiftUI
import PhotosUI

struct SelectImageView: View {
    @State private var firstPickedItem: PhotosPickerItem?
    @State private var secondPickedItem: PhotosPickerItem?
    @State private var firstImage: UIImage?
    @State private var secondImage: UIImage?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 1) {
                if let firstImage {
                    VStack {
                        Label("First Image", systemImage: "")
                            .font(.headline)
                        Image(uiImage: firstImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: .infinity)
                    }
                }
                if let secondImage {
                    VStack {
                        Label("Second Image", systemImage: "")
                            .font(.headline)
                        Image(uiImage: secondImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: .infinity)
                    }
                }
            }
            
            VStack(spacing: 5) {
                PhotosPicker(
                    selection: $firstPickedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select First Image", systemImage: "photo")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.9))
                        .foregroundStyle(Color.white)
                        .cornerRadius(12)
                }
                .onChange(of: firstPickedItem) { oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            firstImage = uiImage
                        }
                    }
                }
                
                PhotosPicker(
                    selection: $secondPickedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select Second Image", systemImage: "photo")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.9))
                        .foregroundStyle(Color.white)
                        .cornerRadius(12)
                }
                .onChange(of: secondPickedItem) { oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            secondImage = uiImage
                        }
                    }
                }
            }

            if firstImage != nil && secondImage != nil  {
                Label("Process", systemImage: "gearshape.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.9))
                    .foregroundStyle(Color.white)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}

#Preview {
    SelectImageView()
}
