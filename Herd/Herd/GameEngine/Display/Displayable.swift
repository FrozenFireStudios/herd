//
//  Displayable.swift
//  sheep
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 360iDevGameJam. All rights reserved.
//

import simd

protocol Displayable {
    var position2D: float2 { get set }
    var rotation: Float { get set }
}
