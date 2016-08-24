//
//  PenEntity.swift
//  Herd
//
//  Created by Marcus Smith on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

class PenEntity: GKEntity {
    
    let obstacle: GKPolygonObstacle
    
    init(centerPoint: float2, rotation: Float, size: float2, display: Displayable) {
        
        obstacle = PenEntity.obstacleFor(centerPoint, rotation: rotation, size: size)
        
        super.init()
        
        let displayComponent = DisplayComponent(display: display)
        displayComponent.display.position2D = centerPoint
        displayComponent.display.heading = rotation
        addComponent(displayComponent)
    }
    
    convenience init(pen: Pen, display: Displayable) {
        self.init(centerPoint: pen.centerPoint, rotation: pen.rotation, size: pen.size, display: display)
    }
    
    class func obstacleFor(centerPoint: float2, rotation: Float, size: float2) -> GKPolygonObstacle {
        
        let leftX: Float = centerPoint.x - (size.x / 2)
        let rightX: Float = centerPoint.x + (size.x / 2)
        let topY: Float = centerPoint.y + (size.y / 2)
        let bottomY: Float = centerPoint.y - (size.y / 2)

        // TODO: Math to rotate?
        let points: [float2] = [
            float2(leftX, bottomY),
            float2(leftX, topY),
            float2(rightX, topY),
            float2(rightX, bottomY),
            float2(rightX - 1, bottomY),
            float2(rightX - 1, topY - 1),
            float2(leftX + 1, topY - 1),
            float2(leftX + 1, bottomY)
        ]
        
        return GKPolygonObstacle(points: UnsafeMutablePointer(points), count: points.count)
    }
    
}
