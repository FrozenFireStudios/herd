//
//  GameEngine.swift
//  Herd
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

class GameEngine {
    
    private let map: Map
    
    private var dog: DogEntity!
    private var dogTarget: DogTargetEntity!
    
    private var entities = Set<GKEntity>()
    private var entitiesToRemove = Set<GKEntity>()
    
    private lazy var componentSystems: [GKComponentSystem] = {
        return [
            GKComponentSystem(componentClass: MovementComponent.self)
        ]
    }()
    
    init(map: Map) {
        self.map = map
    }
    
    var addDisplayable: ((Displayable) -> Void)?
    var removeDisplayable: ((Displayable) -> Void)?
    
    func load() {
        let penEntity = PenEntity(pen: map.pen)
        add(penEntity)
        
        let obstacles = map.edgeObstacles + [penEntity.obstacle]
        
        dogTarget = DogTargetEntity(position: map.dogPosition)
        add(dogTarget)
        
        let targetAgent = dogTarget.componentForClass(MovementComponent.self)!
        
        dog = DogEntity(position: map.dogPosition, targetAgent: targetAgent, obstacles: obstacles)
        add(dog)
        
        let dogAgent = dog!.componentForClass(MovementComponent.self)!
        
        map.sheepPositions.forEach { add(SheepEntity(position: $0, dogAgent: dogAgent, obstacles: obstacles)) }
    }
    
    func update(deltaTime: NSTimeInterval) {
        componentSystems.forEach { $0.updateWithDeltaTime(deltaTime) }
        
        entitiesToRemove.forEach { entity in
            componentSystems.forEach { $0.removeComponentWithEntity(entity) }
        }
        
        entitiesToRemove.removeAll()
    }
    
    func moveDogToPoint(point: float2) {
        dogTarget?.moveToPoint(point)
    }
    
    func bark() {
        dog?.bark()
    }
    
    private func add(entity: GKEntity) {
        entities.insert(entity)
        componentSystems.forEach { $0.addComponentWithEntity(entity) }
        
        if let displayComponent = entity.componentForClass(DisplayComponent.self) {
            addDisplayable?(displayComponent.display)
        }
    }
    
    private func remove(entity: GKEntity) {
        if let displayComponent = entity.componentForClass(DisplayComponent.self) {
            removeDisplayable?(displayComponent.display)
        }
        
        entities.remove(entity)
        entitiesToRemove.insert(entity)
    }
}
