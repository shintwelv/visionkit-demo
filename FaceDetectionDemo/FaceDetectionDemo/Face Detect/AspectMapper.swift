//
//  AspectMapper.swift
//  FaceDetectionDemo
//
//  Created by ShinIl Heo on 10/14/25.
//

import Foundation

struct AspectFitMapper {
    let imageSize: CGSize
    let containerSize: CGSize
    
    var scale: CGFloat {
        let sx = containerSize.width  / imageSize.width
        let sy = containerSize.height / imageSize.height
        return min(sx, sy)
    }
    var fittedImageSize: CGSize {
        .init(width: imageSize.width * scale, height: imageSize.height * scale)
    }
    var xOffset: CGFloat { (containerSize.width  - fittedImageSize.width)  / 2 }
    var yOffset: CGFloat { (containerSize.height - fittedImageSize.height) / 2 }
    
    func toViewSpace(_ p: CGPoint) -> CGPoint {
        CGPoint(x: p.x * scale + xOffset, y: p.y * scale + yOffset)
    }
}
