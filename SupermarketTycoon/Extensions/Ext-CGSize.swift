//
//  Ext-CGSize.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 05/02/2021.
//

import Foundation


extension CGSize {
    /// Distance of vector. Calculated with pythagoras's theorem.
    var distance: CGFloat {
        sqrt(distanceSquared)
    }
    
    /// Squared distance of a vector. Saves efficiency of square root.
    var distanceSquared: CGFloat {
        width * width + height * height
    }
    
    /// Unit vector of a vector.
    var unitVector: CGSize {
        scale(by: 1 / distance)
    }
    
    /// Scale a vector by a scale factor.
    func scale(by factor: CGFloat) -> CGSize {
        CGSize(width: width * factor, height: height * factor)
    }
}
