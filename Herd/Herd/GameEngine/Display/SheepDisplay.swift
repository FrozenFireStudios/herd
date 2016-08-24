//
//  SheepDisplay.swift
//  Herd
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import SceneKit

class SheepDisplay: Displayable {
    
    lazy var node: SCNNode = {
        let geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        return SCNNode(geometry: geometry)
    }()
    
    //==========================================================================
    // MARK: - Displayable
    //==========================================================================
    
    var position2D: float2 {
        get {
            return float2(x: node.position.x, y: node.position.y)
        }
        set {
            node.position.x = newValue.x
            node.position.y = newValue.y
        }
    }
    
    var heading: Float {
        get {
            return node.rotation.w
        }
        set {
            node.rotation = SCNVector4(0, 1, 0, newValue)
        }
    }
}
