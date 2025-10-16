//
//  CompareImageResultViewModel.swift
//  CompareTwoImageDemo
//
//  Created by ShinIl Heo on 10/16/25.
//

import UIKit

final class CompareImageResultViewModel: ObservableObject {
    let firstImage: UIImage
    let secondImage: UIImage
    
    @Published var compareResult: String = ""
    
    init(firstImage: UIImage, secondImage: UIImage) {
        self.firstImage = firstImage
        self.secondImage = secondImage
    }
    
    func compareImages() {
        Task {
            await MainActor.run {
                compareResult = "Comparison Ended. Not same"
            }
        }
    }
}
