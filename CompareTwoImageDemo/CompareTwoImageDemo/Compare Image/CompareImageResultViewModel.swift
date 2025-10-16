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
            let imageComparator: ImageComparable = AppleVisionImageComparator()
            let imageCompareResult: ImageCompareResult? = imageComparator.compareImages(first: firstImage, second: secondImage)
            await MainActor.run {
                if let imageCompareResult {
                    self.compareResult = """
                    featrue distance = \(imageCompareResult.distance)
                    Two images look \(imageCompareResult.similar ? "similar" : "not similar")
                    """
                } else {
                    self.compareResult = "Failed to compare images"
                }
            }
        }
    }
}
