//
//  Scaling.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 06/02/2021.
//

import Foundation


/// Scales points to fit the game scene correctly.
enum Scaling {
    static var ratio: CGFloat = {
        let originalSize = CGSize(width: 1440, height: 900)
        return Global.scene!.size.width / originalSize.width
    }()
    
    static func point(_ point: CGPoint) -> CGPoint {
        CGPoint(x: point.x * ratio, y: point.y * ratio)
    }
    
    static func size(_ size: CGSize) -> CGSize {
        CGSize(width: size.width * ratio, height: size.height * ratio)
    }
}
