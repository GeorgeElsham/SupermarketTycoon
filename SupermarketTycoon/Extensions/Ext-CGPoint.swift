//
//  Ext-CGPoint.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 05/02/2021.
//

import Foundation


extension CGPoint {
    /// Finds the vector between two points.
    func difference(to point: CGPoint) -> CGSize {
        CGSize(width: point.x - x, height: point.y - y)
    }
    
    /// Offsets a point by a given vector.
    func offset(by vector: CGSize) -> CGPoint {
        CGPoint(x: x + vector.width, y: y + vector.height)
    }
}
