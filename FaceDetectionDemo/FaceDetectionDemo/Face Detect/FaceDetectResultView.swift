//
//  FaceDetectResultView.swift
//  FaceDetectionDemo
//
//  Created by ShinIl Heo on 10/14/25.
//

import SwiftUI

struct FaceDetectResultView: View {
    @StateObject var viewModel: FaceDetectResultViewModel
    
    var image: UIImage { viewModel.image }
    
    init(image: UIImage) {
        _viewModel = StateObject(wrappedValue: FaceDetectResultViewModel(image: image))
    }
    
    var pointRadius: CGFloat = 5
    var pointStrokeWidth: CGFloat = 2
    
    var body: some View {
        GeometryReader { geo in
            let mapper = AspectFitMapper(
                imageSize: CGSize(width: image.size.width, height: image.size.height),
                containerSize: geo.size
            )
            
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                
                ForEach(Array(viewModel.facePoints.enumerated()), id:\.offset) { _, p in
                    let vp = mapper.toViewSpace(p)
                    Circle()
                        .strokeBorder(.red, lineWidth: pointStrokeWidth)
                        .background(Circle().fill(Color.red.opacity(0.25)))
                        .frame(width: pointRadius*2, height:pointRadius*2)
                        .position(vp)
                }
            }
            .contentShape(Rectangle())
        }
    }
    
}

struct FaceDetectResultView_Previews: PreviewProvider {
    static var sampleImage: UIImage {
        let size = CGSize(width: 400, height: 300)
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        UIColor.black.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return img
    }

    static var previews: some View {
        FaceDetectResultView(image: sampleImage)
    }
}
