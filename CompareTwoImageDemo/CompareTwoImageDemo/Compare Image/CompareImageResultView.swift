//
//  CompareImageResultView.swift
//  CompareTwoImageDemo
//
//  Created by ShinIl Heo on 10/16/25.
//

import SwiftUI

struct CompareImageResultView: View {
    @StateObject var viewModel: CompareImageResultViewModel
    
    var firstImage: UIImage
    var secondImage: UIImage
    
    init(firstImage: UIImage, secondImage: UIImage) {
        self.firstImage = firstImage
        self.secondImage = secondImage
        _viewModel = StateObject(wrappedValue: CompareImageResultViewModel(firstImage: firstImage, secondImage: secondImage))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 1) {
                VStack {
                    Label("First Image", systemImage: "")
                        .font(.headline)
                    Image(uiImage: firstImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                VStack {
                    Label("Second Image", systemImage: "")
                        .font(.headline)
                    Image(uiImage: secondImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
            }
            
            ScrollView {
                Text(viewModel.compareResult)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
                .padding()
                .background(Color.gray.opacity(0.3))
        }
        .padding()
        .onAppear {
            viewModel.compareImages()
        }
    }
}

#Preview {
    CompareImageResultView(
        firstImage: UIImage(named: "Tim_Cook1")!,
        secondImage: UIImage(named: "Tim_Cook2")!
    )
}
