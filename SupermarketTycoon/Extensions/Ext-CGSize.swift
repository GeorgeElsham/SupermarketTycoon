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
}
