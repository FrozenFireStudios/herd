//
//  OurDisplayable.swift
//  Herd
//
//  Created by Marcus Smith on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import SceneKit

protocol OurDisplayableDelegate: class {
    func convertPoint2Dto3D(point: CGPoint) -> SCNVector3
    func convertPoint3Dto2D(point: SCNVector3) -> CGPoint
}

class OurDisplayable: Displayable {
    
    var node: SCNNode
    
    init(node: SCNNode) {
        self.node = node
    }
    
    weak var delegate: OurDisplayableDelegate?
    
    //==========================================================================
    // MARK: - Displayable
    //==========================================================================
    
    var position2D: float2 {
        get {
            let position = delegate?.convertPoint3Dto2D(node.position) ?? .zero
            return position.asFloat2
        }
        set {
            node.position = delegate?.convertPoint2Dto3D(newValue.asCGPoint) ?? SCNVector3Zero
        }
    }
    
    var heading: Float {
        get {
            return node.eulerAngles.y
        }
        set {
            node.eulerAngles = SCNVector3(node.eulerAngles.x, newValue, node.eulerAngles.z)
        }
    }
}
