//
//  SheepBehavior.swift
//  Herd
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

class SheepBehavior: GKBehavior {
    
    private static let wanderSpeed: Float = 10
    
    init(dogAgent: GKAgent, obstacles: [GKObstacle]) {
        super.init()
        
        let wanderGoal = GKGoal(toWander: SheepBehavior.wanderSpeed)
        setWeight(0.3, forGoal: wanderGoal)
        
        let dogGoal = GKGoal(toAvoidAgents: [dogAgent], maxPredictionTime: 2)
        setWeight(1, forGoal: dogGoal)
        
        let obstacleGoal = GKGoal(toAvoidObstacles: obstacles, maxPredictionTime: 1)
        setWeight(1, forGoal: obstacleGoal)
    }
}
