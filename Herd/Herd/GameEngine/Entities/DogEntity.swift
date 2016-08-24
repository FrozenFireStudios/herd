//
//  DogEntity.swift
//  sheep
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 360iDevGameJam. All rights reserved.
//

import GameKit

class DogEntity: GKEntity {
    
    init(position: float2, display: Displayable, targetAgent: GKAgent, obstacles: [GKObstacle]) {
        super.init()
        
        let displayComponent = DisplayComponent(display: display)
        displayComponent.display.position2D = position
        addComponent(displayComponent)
        
        let movementComponent = MovementComponent(maxSpeed: 200, maxAcceleration: 300, radius: 150)
        movementComponent.position = position
        movementComponent.behavior = DogBehavior(target: targetAgent, obstacles: obstacles)
        addComponent(movementComponent)
        
        let soundComponent = SoundComponent()
        addComponent(soundComponent)
    }
    
    func bark() {
        guard let soundComponent = componentForClass(SoundComponent.self) else { return }
        
        let soundAngle = componentForClass(MovementComponent.self)?.rotation
        soundComponent.makeSound(.BarkLoudKey, angle: soundAngle)
    }
}
