//
//  DogBehavior.swift
//  Herd
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

class DogBehavior: GKBehavior {
    
    private static let dogSpeed: Float = 200
    
    init(target: GKAgent, obstacles: [GKObstacle]) {
        super.init()
        
        let seekGoal = GKGoal(toSeekAgent: target)
        setWeight(0.8, forGoal: seekGoal)
        
        let speedGoal = GKGoal(toReachTargetSpeed: 0)
        setWeight(0.1, forGoal: speedGoal)
//        
//        let obstacleGoal = GKGoal(toAvoidObstacles: obstacles, maxPredictionTime: 1)
//        setWeight(1, forGoal: obstacleGoal)
    }
}
