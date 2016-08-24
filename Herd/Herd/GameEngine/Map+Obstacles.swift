//
//  Map+Obstacles.swift
//  Herd
//
//  Created by Marcus Smith on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

extension Map {
    var edgeObstacles: [GKPolygonObstacle] {
        let leftX = Float(0)
        let rightX = size.x
        let bottomY = Float(0)
        let topY = size.y
        
        let leftObstacle = obstacleFor(origin: float2(leftX, bottomY), size: float2(1, size.y))
        let topObstacle = obstacleFor(origin: float2(leftX, topY - 1), size: float2(size.x, 1))
        let rightObstacle = obstacleFor(origin: float2(rightX - 1, bottomY), size: float2(1, size.y))
        let bottomObstacle = obstacleFor(origin: float2(leftX, bottomY), size: float2(size.x, 1))
        
        return [leftObstacle, topObstacle, rightObstacle, bottomObstacle]
    }
}

private func obstacleFor(origin origin: float2, size: float2) -> GKPolygonObstacle {
    let points: [float2] = [
        origin,
        float2(origin.x, origin.y + size.y),
        float2(origin.x + size.x, origin.y + size.y),
        float2(origin.x + size.x, origin.y)
    ]
    
    return GKPolygonObstacle(points: UnsafeMutablePointer(points), count: points.count)
}
