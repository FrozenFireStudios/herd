//
//  SheepEntity.swift
//  sheep
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 360iDevGameJam. All rights reserved.
//

import GameKit

class SheepEntity: GKEntity {
    
    init(position: float2, dogAgent: GKAgent, obstacles: [GKObstacle]) {
        super.init()
        
        let displayComponent = DisplayComponent(display: SheepDisplay())
        displayComponent.display.position2D = position
        addComponent(displayComponent)
        
        let movementComponent = MovementComponent(maxSpeed: 1, maxAcceleration: 1, radius: 1)
        movementComponent.behavior = SheepBehavior(dogAgent: dogAgent, obstacles: obstacles)
        addComponent(movementComponent)
        
        let soundComponent = SoundComponent(soundName: "sheep")
        addComponent(soundComponent)
    }
}
