//
//  DogTargetEntity.swift
//  Herd
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

class DogTargetEntity: GKEntity {
    
    init(position: float2) {
        super.init()
        
        let movementComponent = MovementComponent(maxSpeed: 0, maxAcceleration: 0, radius: 0)
        movementComponent.position = position
        addComponent(movementComponent)
    }
    
    func moveToPoint(point: float2) {
        componentForClass(MovementComponent.self)?.position = point
    }
}
