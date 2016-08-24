//
//  ScoringComponent.swift
//  Herd
//
//  Created by Marcus Smith on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

class ScoringComponent: GKComponent {
    
    private let pen: PenEntity
    private(set) var score: Int = 0
    
    init(pen: PenEntity) {
        self.pen = pen
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        score = isInPen ? 1 : 0
    }
    
    private var isInPen: Bool {
        guard let position = entity?.componentForClass(MovementComponent.self)?.position else {
            return false
        }
        
        if position.x < pen.centerPoint.x - (pen.size.x / 2) {
            return false
        }
        if position.x > pen.centerPoint.x + (pen.size.x / 2) {
            return false
        }
        if position.y < pen.centerPoint.y - (pen.size.y / 2) {
            return false
        }
        if position.y > pen.centerPoint.y + (pen.size.y / 2) {
            return false
        }
        
        return true
    }
}
