//
//  AppleVisionImageComparator.swift
//  CompareTwoImageDemo
//
//  Created by ShinIl Heo on 10/16/25.
//

import UIKit
import Vision

final class AppleVisionImageComparator: ImageComparable {
    func compareImages(first img1: UIImage, second img2: UIImage) -> ImageCompareResult? {
        guard let img1Feature = getFeature(image: img1),
              let img2Feature = getFeature(image: img2) else { return nil }
        
        var distance: Float = 0.0
        do {
            try img1Feature.computeDistance(&distance, to: img2Feature)
            return .init(
                similar: distance < 0.5,
                distance: distance
            )
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getFeature(image: UIImage) -> VNFeaturePrintObservation? {
        guard let cgImage = image.cgImage else { return nil }
        
        let request = VNGenerateImageFeaturePrintRequest()
        request.revision = VNGenerateImageFeaturePrintRequestRevision2
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        do {
            try handler.perform([request])
            let result = request.results?.first
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
