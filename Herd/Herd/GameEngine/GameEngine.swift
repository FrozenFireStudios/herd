//
//  GameEngine.swift
//  Herd
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

protocol GameEngineDisplayDelegate: class {
    func addDisplayable(displayable: Displayable)
    func removeDisplayable(displayable: Displayable)
    func displayableForEntityType(entityType: DisplayableEntityType) -> Displayable
}

protocol GameEngineScoreDelegate: class {
    func scoreChanged(score: Int, totalPossible: Int)
}

class GameEngine {
    
    private let map: Map
    var mapLoaded = false
    
    var score = 0
    private var previousScore = 0
    
    private var dog: DogEntity!
    private var dogTarget: DogTargetEntity!
    
    private var entities = Set<GKEntity>()
    private var entitiesToRemove = Set<GKEntity>()
    
    private lazy var componentSystems: [GKComponentSystem] = {
        return [
            GKComponentSystem(componentClass: MovementComponent.self),
            GKComponentSystem(componentClass: ScoringComponent.self)
        ]
    }()
    
    weak var displayDelegate: GameEngineDisplayDelegate?
    weak var scoreDelegate: GameEngineScoreDelegate?
    
    init(map: Map, displayDelegate: GameEngineDisplayDelegate) {
        self.map = map
        self.displayDelegate = displayDelegate
    }
    
    func load() {
        guard !mapLoaded else { return }
        guard let delegate = displayDelegate else { fatalError("Cannot load map without a delegate") }
        
        let penEntity = PenEntity(pen: map.pen, display: delegate.displayableForEntityType(.Pen(size: map.pen.size)))
        add(penEntity)
        
        let obstacles = map.edgeObstacles// + penEntity.obstacles
        
        dogTarget = DogTargetEntity(position: map.dogPosition)
        add(dogTarget)
        
        let targetAgent = dogTarget.componentForClass(MovementComponent.self)!
        
        dog = DogEntity(position: map.dogPosition, display: delegate.displayableForEntityType(.Dog), targetAgent: targetAgent, obstacles: obstacles)
        add(dog)
        
        let dogAgent = dog.componentForClass(MovementComponent.self)!
        
        map.sheepPositions.forEach { add(SheepEntity(position: $0, display: delegate.displayableForEntityType(.Sheep), dogAgent: dogAgent, pen: penEntity, obstacles: obstacles)) }
        
        mapLoaded = true
    }
    
    func update(deltaTime: NSTimeInterval) {
        componentSystems.forEach { $0.updateWithDeltaTime(deltaTime) }
        
        let scoringComponents = entities.flatMap { $0.componentForClass(ScoringComponent.self) }
        score = scoringComponents.reduce(0) { $0 + $1.score }
        
        if score != previousScore {
            scoreDelegate?.scoreChanged(score, totalPossible: scoringComponents.count)
            previousScore = score
        }
        
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
            displayDelegate?.addDisplayable(displayComponent.display)
        }
    }
    
    private func remove(entity: GKEntity) {
        if let displayComponent = entity.componentForClass(DisplayComponent.self) {
            displayDelegate?.removeDisplayable(displayComponent.display)
        }
        
        entities.remove(entity)
        entitiesToRemove.insert(entity)
    }
}
