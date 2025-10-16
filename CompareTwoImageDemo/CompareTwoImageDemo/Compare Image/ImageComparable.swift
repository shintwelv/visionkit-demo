//
//  ImageComparable.swift
//  CompareTwoImageDemo
//
//  Created by ShinIl Heo on 10/16/25.
//

import UIKit

struct ImageCompareResult {
    let similar: Bool
    let distance: Float
}

protocol ImageComparable {
    func compareImages(first img1: UIImage, second img2: UIImage) -> ImageCompareResult?
}
