//
//  PenEntity.swift
//  Herd
//
//  Created by Marcus Smith on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

class PenEntity: GKEntity {
    
    let obstacles: [GKPolygonObstacle]
    let centerPoint: float2
    let rotation: Float
    let size: float2
    
    init(centerPoint: float2, rotation: Float, size: float2, display: Displayable) {
        
        obstacles = PenEntity.obstaclesFor(centerPoint, rotation: rotation, size: size, thickness: 4)
        self.centerPoint = centerPoint
        self.rotation = rotation
        self.size = size
        
        super.init()
        
        let displayComponent = DisplayComponent(display: display)
        displayComponent.display.position2D = centerPoint
        displayComponent.display.heading = rotation
        addComponent(displayComponent)
    }
    
    convenience init(pen: Pen, display: Displayable) {
        self.init(centerPoint: pen.centerPoint, rotation: pen.rotation, size: pen.size, display: display)
    }
    
    class func obstaclesFor(centerPoint: float2, rotation: Float, size: float2, thickness: Float) -> [GKPolygonObstacle] {
        
        let leftX: Float = centerPoint.x - (size.x / 2)
        let rightX: Float = centerPoint.x + (size.x / 2)
        let topY: Float = centerPoint.y + (size.y / 2)
        let bottomY: Float = centerPoint.y - (size.y / 2)
        
        let leftEdgePoints: [float2] = [
            float2(leftX, bottomY),
            float2(leftX, topY),
            float2(leftX + thickness, topY),
            float2(leftX + thickness, bottomY)
        ]
        
        let bottomEdgePoints: [float2] = [
            float2(leftX, bottomY),
            float2(leftX, bottomY + thickness),
            float2(rightX, bottomY + thickness),
            float2(rightX, bottomY)
        ]
        
        let rightEdgePoints: [float2] = [
            float2(rightX, topY),
            float2(rightX, bottomY),
            float2(rightX - thickness, bottomY),
            float2(rightX - thickness, topY)
        ]

        // TODO: Math to rotate?
        let polygons: [GKPolygonObstacle] = [
            GKPolygonObstacle(points: UnsafeMutablePointer(leftEdgePoints), count: leftEdgePoints.count),
            GKPolygonObstacle(points: UnsafeMutablePointer(bottomEdgePoints), count: bottomEdgePoints.count),
            GKPolygonObstacle(points: UnsafeMutablePointer(rightEdgePoints), count: rightEdgePoints.count)
        ]
        
        return polygons
    }
}
