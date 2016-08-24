//
//  float2Help.swift
//  Herd
//
//  Created by Ryan Poolos on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import QuartzCore
import simd

extension CGPoint {
    var asFloat2: float2 {
        return float2(x.asFloat, y.asFloat)
    }
}

extension float2 {
    var asCGPoint: CGPoint {
        return CGPoint(x: Double(x), y: Double(y))
    }
    
    var asCGSize: CGSize {
        return CGSize(width: Double(x), height: Double(y))
    }
}

extension CGFloat {
    var asFloat: Float {
        return Float(self)
    }
}

extension CGSize {
    var asFloat2: float2 {
        return float2(width.asFloat, height.asFloat)
    }
}

extension Float {
    var asCGFloat: CGFloat {
        return CGFloat(self)
    }
}