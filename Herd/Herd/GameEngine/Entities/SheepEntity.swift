//
//  SheepEntity.swift
//  sheep
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 360iDevGameJam. All rights reserved.
//

import GameKit

class SheepEntity: GKEntity {
    
    init(position: float2, display: Displayable, dogAgent: GKAgent, pen: PenEntity, obstacles: [GKObstacle]) {
        super.init()
        
        let displayComponent = DisplayComponent(display: display)
        displayComponent.display.position2D = position
        addComponent(displayComponent)
        
        let movementComponent = MovementComponent(maxSpeed: 50, maxAcceleration: 50, radius: 12)
        movementComponent.behavior = SheepBehavior(dogAgent: dogAgent, obstacles: obstacles)
        addComponent(movementComponent)
        
        let soundComponent = SoundComponent()
        addComponent(soundComponent)
        
        let scoringComponent = ScoringComponent(pen: pen)
        addComponent(scoringComponent)
    }
}
