//
//  PenDisplay.swift
//  Herd
//
//  Created by Marcus Smith on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import SpriteKit

class PenDisplay: Displayable {
    var position2D: float2 = float2(0, 0)
    var heading: Float = 0
    let size: float2
    
    init(size: float2) {
        self.size = size
    }
}
