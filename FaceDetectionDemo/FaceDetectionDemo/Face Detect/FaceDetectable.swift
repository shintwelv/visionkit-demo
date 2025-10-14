//
//  FaceDetectable.swift
//  FaceDetectionDemo
//
//  Created by ShinIl Heo on 10/14/25.
//

import UIKit
import Vision

public protocol FaceDetectable {
    func detectFaces(in image: UIImage) async throws -> [DetectedFace]
}

public struct DetectedFace: Sendable {
    public let id: Int
    public let boundingBox: CGRect
    public let roll: Float?
    public let yaw: Float?
    public let confidence: Float?
    public let landmarks: [FaceLandmarks]
}

public struct FaceLandmarks: Sendable {
    public let kind: FaceLandmarkKind
    public let points: [CGPoint]
}

public enum FaceLandmarkKind: String, Sendable {
    case faceContour, leftEye, rightEye, leftEyebrow, rightEyebrow
    case nose, noseCrest, medianLine, outerLips, innerLips, leftPupil, rightPupil
}

public enum FaceDetectorError: Error {
    case invalidImage
    case underlying(Error)
}
