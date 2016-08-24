//
//  DogBehavior.swift
//  Herd
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

class DogBehavior: GKBehavior {
    
    private static let dogSpeed: Float = 10
    
    init(target: GKAgent, obstacles: [GKObstacle]) {
        super.init()
        
        let seekGoal = GKGoal(toSeekAgent: target)
        let speedGoal = GKGoal(toReachTargetSpeed: DogBehavior.dogSpeed)
        let obstacleGoal = GKGoal(toAvoidObstacles: obstacles, maxPredictionTime: 1)
        
        [seekGoal, speedGoal, obstacleGoal].forEach { setWeight(1, forGoal: $0) }
    }
}
