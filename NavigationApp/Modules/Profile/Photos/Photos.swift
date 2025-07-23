//
//  PhotoExamples.swift
//  Navigation
//

import UIKit
import iOSIntPackage

final class Photos {
    
    static let shared = Photos()
    
    let examples: [UIImage]
    
    private init() {
        examples = Images.allCases.compactMap {
            $0.image(name: $0).downsampled(maxDimension: 400)
        }
    }
}
