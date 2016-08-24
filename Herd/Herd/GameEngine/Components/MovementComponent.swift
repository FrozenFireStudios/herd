//
//  MovementComponent.swift
//  sheep
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 360iDevGameJam. All rights reserved.
//

import GameKit

class MovementComponent: GKAgent2D, GKAgentDelegate {
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float) {
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.1
    }
    
    func agentWillUpdate(agent: GKAgent) {
        guard let displayComponent = entity?.componentForClass(DisplayComponent.self) else { return }
        
        position = displayComponent.display.position2D
        rotation = displayComponent.display.rotation
    }
    
    func agentDidUpdate(agent: GKAgent) {
        guard let displayComponent = entity?.componentForClass(DisplayComponent.self) else { return }
        
        displayComponent.display.position2D = position
        displayComponent.display.rotation = rotation
    }
}
