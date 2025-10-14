//
//  FaceDetector.swift
//  FaceDetectionDemo
//
//  Created by ShinIl Heo on 10/14/25.
//

import UIKit
import Vision

public final class AppleVisionFaceDetector: FaceDetectable {

    public init() {}

    public func detectFaces(in image: UIImage) async throws -> [DetectedFace] {
        guard let cgImage = image.cgImage else { throw FaceDetectorError.invalidImage }
        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        let orientation = cgImagePropertyOrientation(from: image.imageOrientation)

        let request: VNRequest = VNDetectFaceLandmarksRequest()

        let observations: [VNFaceObservation] = try await withCheckedThrowingContinuation { cont in
            let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
            do {
                try handler.perform([request])
                if let faces = request.results as? [VNFaceObservation] {
                    cont.resume(returning: faces)
                } else {
                    cont.resume(returning: [])
                }
            } catch {
                cont.resume(throwing: FaceDetectorError.underlying(error))
            }
        }

        var idx = 0
        let result: [DetectedFace] = observations.map { obs in
            defer { idx += 1 }

            let bbox = convertNormalizedRect(obs.boundingBox, imageSize: imageSize)
            let roll = obs.roll?.floatValue
            let yaw  = obs.yaw?.floatValue
            let conf = obs.confidence

            let landmarks: [FaceLandmarks] = mapLandmarks(obs, imageSize: imageSize)

            return DetectedFace(
                id: idx,
                boundingBox: bbox,
                roll: roll,
                yaw: yaw,
                confidence: conf,
                landmarks: landmarks
            )
        }

        return result
    }

    // MARK: - Helpers

    /// convert nomalized rect to image pixel position
    private func convertNormalizedRect(_ rect: CGRect, imageSize: CGSize) -> CGRect {
        // Vision: origin is bottom-left; UIKit/CGImage pixel space: origin is top-left
        let x = rect.origin.x * imageSize.width
        let height = rect.size.height * imageSize.height
        let yFromBottom = rect.origin.y * imageSize.height
        // convert to top-left origin
        let y = (imageSize.height - yFromBottom - height)
        let w = rect.size.width * imageSize.width
        return CGRect(x: x.rounded(.toNearestOrAwayFromZero),
                      y: y.rounded(.toNearestOrAwayFromZero),
                      width: w.rounded(.toNearestOrAwayFromZero),
                      height: height.rounded(.toNearestOrAwayFromZero))
    }

    /// convert nomalized points to image pixel positions
    private func convertNormalizedPoints(_ points: [CGPoint], inFaceRect faceRectPx: CGRect, imageSize: CGSize) -> [CGPoint] {
        // Vision: origin is bottom-left; UIKit/CGImage pixel space: origin is top-left
        return points.map { p in
            let x = faceRectPx.minX + p.x * faceRectPx.width
            let yFromBottom = faceRectPx.minY + p.y * faceRectPx.height
            let y = imageSize.height - yFromBottom
            return CGPoint(x: x, y: y)
        }
    }

    private func mapLandmarks(_ obs: VNFaceObservation, imageSize: CGSize) -> [FaceLandmarks] {
        guard let lmk = obs.landmarks else { return [] }
        let faceRectPx = convertNormalizedRect(obs.boundingBox, imageSize: imageSize)

        func pack(_ comp: VNFaceLandmarkRegion2D?, kind: FaceLandmarkKind) -> FaceLandmarks? {
            guard let comp, comp.pointCount > 0 else { return nil }
            let pts = convertNormalizedPoints(comp.normalizedPoints,
                                              inFaceRect: faceRectPx,
                                              imageSize: imageSize)
            return FaceLandmarks(kind: kind, points: pts)
        }

        var out: [FaceLandmarks] = []
        if let v = pack(lmk.faceContour,   kind: .faceContour) { out.append(v) }
        if let v = pack(lmk.leftEye,       kind: .leftEye) { out.append(v) }
        if let v = pack(lmk.rightEye,      kind: .rightEye) { out.append(v) }
        if let v = pack(lmk.leftEyebrow,   kind: .leftEyebrow) { out.append(v) }
        if let v = pack(lmk.rightEyebrow,  kind: .rightEyebrow) { out.append(v) }
        if let v = pack(lmk.nose,          kind: .nose) { out.append(v) }
        if let v = pack(lmk.noseCrest,     kind: .noseCrest) { out.append(v) }
        if let v = pack(lmk.medianLine,    kind: .medianLine) { out.append(v) }
        if let v = pack(lmk.outerLips,     kind: .outerLips) { out.append(v) }
        if let v = pack(lmk.innerLips,     kind: .innerLips) { out.append(v) }
        if let v = pack(lmk.leftPupil,     kind: .leftPupil) { out.append(v) }
        if let v = pack(lmk.rightPupil,    kind: .rightPupil) { out.append(v) }
        return out
    }

    private func cgImagePropertyOrientation(from uiOrientation: UIImage.Orientation) -> CGImagePropertyOrientation {
        switch uiOrientation {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }
}
