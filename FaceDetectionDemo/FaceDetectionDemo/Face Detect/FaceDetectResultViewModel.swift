//
//  FaceDetectResultViewModel.swift
//  FaceDetectionDemo
//
//  Created by ShinIl Heo on 10/14/25.
//

import UIKit

final class FaceDetectResultViewModel: ObservableObject {
    let image: UIImage
    
    @Published var facePoints: [CGPoint] = []
    
    init(image: UIImage) {
        self.image = image
    }
    
    func detectFace() {
        Task {
            let faceDetector: FaceDetectable = AppleVisionFaceDetector()
            let detectedFaces: [DetectedFace] = try await faceDetector.detectFaces(in: self.image)
            
            let points: [CGPoint] = detectedFaces.flatMap { $0.landmarks }.flatMap { $0.points }
            await MainActor.run {
                self.facePoints = points
            }
        }
    }
}
