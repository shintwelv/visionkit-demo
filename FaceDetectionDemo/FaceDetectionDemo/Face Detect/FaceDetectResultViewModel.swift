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
}
