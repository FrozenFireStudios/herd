//
//  GameViewController.swift
//  Herd
//
//  Created by Ryan Poolos on 8/23/16.
//  Copyright (c) 2016 Frozen Fire Studios. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import AudioKit

class GameViewController: UIViewController, SCNSceneRendererDelegate, GameEngineDisplayDelegate, GameEngineScoreDelegate, OurDisplayableDelegate {
    
    var scnView: SCNView {
        return view as! SCNView
    }
    
    override func loadView() {
        view = SCNView()
    }
    
    var gameEngine: GameEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.1, green: 1.0, blue: 0.1, alpha: 1.0)
        
        let scene = SCNScene()
        
        // Set up the camera
        scene.rootNode.addChildNode(cameraNode)
        
        let groundScene = SCNScene(named: "ground.dae")!
        let groundNode = groundScene.rootNode.childNodeWithName("Grid", recursively: true)!
        groundNode.position = SCNVector3(x: 0, y: -1, z: 0)
        scene.rootNode.addChildNode(groundNode)
        
        // This is a really lazy light source. But its kinda sun like...
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 25, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        let ambient = SCNNode()
        ambient.light = SCNLight()
        ambient.light?.type = SCNLightTypeAmbient
        ambient.light?.color = UIColor.darkGrayColor()
        ambient.position = SCNVector3(x: 0, y: 25, z: 0)
        scene.rootNode.addChildNode(ambient)
        
        // Add our scene to the view
        scnView.scene = scene
        scnView.showsStatistics = true
        scnView.delegate = self
        
        // Setup some Gestures
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        view.addGestureRecognizer(panGesture)
//
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
//        view.addGestureRecognizer(pinchGesture)
        
        // Setup Labels
        view.addSubview(scoreLabel)
        view.addSubview(timeLabel)
        
        let margin = CGFloat(10)
        
        scoreLabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: margin).active = true
        timeLabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: margin).active = true
        
        scoreLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 2 * margin).active = true
        timeLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -2 * margin).active = true
        scoreLabel.rightAnchor.constraintEqualToAnchor(timeLabel.leftAnchor, constant: 2 * margin).active = true
        
        scoreLabel.text = "Score: 0"
        timeLabel.text = "Time: -"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if gameEngine == nil {
            let mapSize = view.frame.size.asFloat2
            
            let dogPosition = CGPoint(x: view.frame.midX, y: view.frame.midY).asFloat2
            let sheepPositions = random(numberOfPoints: 3, forSize: view.frame.size).map {$0.asFloat2}
            
            let penCenter = CGPoint(x: view.frame.midX, y: 64.0).asFloat2
            let penSize = CGSize(width: 128.0, height: 128.0).asFloat2
            
            let pen = Pen(centerPoint: penCenter, rotation: 0.0, size: penSize)
            let map = Map(size: mapSize, time: 60, dogPosition: dogPosition, sheepPositions: sheepPositions, pen: pen)
            
            gameEngine = GameEngine(map: map, displayDelegate: self)
            gameEngine?.scoreDelegate = self
            gameEngine?.load()
            
            timeRemaining = NSTimeInterval(map.time)
        }
        
        scnView.playing = true
        Conductor.sharedInstance.playSound(forKey: .BackgroundMusicKey)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    //==========================================================================
    // MARK: - Update
    //==========================================================================
    
    var lastTime: NSTimeInterval = 0.0
    var timeRemaining: NSTimeInterval?
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        let delta = lastTime != 0 ? time - lastTime : 0
        lastTime = time
        gameEngine?.update(delta)
        
        if let remaining = timeRemaining {
            let newTime = remaining - delta
            timeRemaining = newTime
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.timeLabel.text = "Time: \(Int(newTime))"
            })
            
            if newTime <= 0 {
                gameOver(gameEngine?.score ?? 0, won: false)
            }
        }
    }
    
    //==========================================================================
    // MARK: - GameEngineDisplayDelegate
    //==========================================================================
    
    func addDisplayable(displayable: Displayable) {
        guard let ourDisplayable = displayable as? OurDisplayable else { return }
        scnView.scene?.rootNode.addChildNode(ourDisplayable.node)
    }
    
    func removeDisplayable(displayable: Displayable) {
        guard let displayable = displayable as? OurDisplayable else { return }
        displayable.node.removeFromParentNode()
    }
    
    func displayableForEntityType(entity: DisplayableEntityType) -> Displayable {
        let displayable: OurDisplayable
        
        switch entity {
        case .Dog:
            let scene = SCNScene(named: "dog.dae")!
            let node = scene.rootNode.childNodeWithName("Doberman_by_AlexLashko", recursively: true)!
            displayable = OurDisplayable(node: node)
        case .Pen(let size):
            let size3D = convertSize2Dto3D(size.asCGSize)
            let box = SCNBox(width: size3D.x.asCGFloat, height: 0.25, length: size3D.z.asCGFloat, chamferRadius: 0.0)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.brownColor()
            box.materials = [material]
            
            let penBlock = SCNNode(geometry: box)
            displayable = OurDisplayable(node: penBlock)
        case .Sheep:
            let scene = SCNScene(named: "Sheep.dae")!
            let node = scene.rootNode.childNodeWithName("sheep", recursively: true)!
            displayable = OurDisplayable(node: node)
        }
        
        displayable.delegate = self
        return displayable
    }
    
    //==========================================================================
    // MARK: - GameEngineDisplayDelegate
    //==========================================================================
    
    func scoreChanged(score: Int, totalPossible: Int) {
        dispatch_async(dispatch_get_main_queue(), {
            self.scoreLabel.text = "Score: \(score)"
        })
        
        if score == totalPossible {
            gameOver(score, won: true)
        }
    }
    
    //==========================================================================
    // MARK: - GameEngineDisplayDelegate
    //==========================================================================

    func gameOver(score: Int, won: Bool) {
        scnView.playing = false
        dispatch_async(dispatch_get_main_queue()) { 
            let gameOverVC = GameOverViewController(score: score, won: won)
            self.navigationController?.pushViewController(gameOverVC, animated: true)
        }
    }
    
    //==========================================================================
    // MARK: - OurDisplayableDelegate
    //==========================================================================
    
    func convertSize2Dto3D(size: CGSize) -> SCNVector3 {
        let origin = convertPoint2Dto3D(CGPointZero)
        let maxPoint = convertPoint2Dto3D(CGPoint(x: view.frame.size.width, y: view.frame.size.height))
        
        let width3D = abs(origin.x) + abs(maxPoint.x)
        let height3D = abs(origin.z) + abs(maxPoint.z)
        
        let widthRatio = Float(size.width / view.frame.size.width)
        let heightRatio = Float(size.height / view.frame.size.height)
        
        return SCNVector3(x: width3D * widthRatio, y: 0.0, z: height3D * heightRatio)
    }
    
    func convertPoint3Dto2D(point: SCNVector3) -> CGPoint {
        let projectedPoint = scnView.projectPoint(point)
        
        return CGPoint(x: Double(projectedPoint.x), y: Double(projectedPoint.y))
    }
    
    func convertPoint2Dto3D(point: CGPoint) -> SCNVector3 {
        // The zeropoint for the z isn't actually even, so grab our origin.
        let projectedOrigin = scnView.projectPoint(SCNVector3Zero)
        
        // Convert to 3D with our x/y plus the origin z
        let touchPoint = SCNVector3(x: Float(point.x), y: Float(point.y), z: projectedOrigin.z)
        
        // unproject it to 3D space
        let convertedPoint = scnView.unprojectPoint(touchPoint)
        
        return convertedPoint
    }
    
    //==========================================================================
    // MARK: - Gestures
    //==========================================================================
    
    var touchedNode: SCNNode?
    func handlePan(gesture: UIPanGestureRecognizer) {
        let point = gesture.locationInView(view)
        
        if gesture.state == .Began {
            let hitResults = scnView.hitTest(point, options: nil)
            touchedNode = hitResults.first?.node
        }
        
        if gesture.state == .Changed {
            touchedNode?.position = convertPoint2Dto3D(point)
        }
    }
    
    func handleDoubleTap(gesture: UITapGestureRecognizer) {
        // temp until we get angles to feed the sound method farther in 
        let point = gesture.locationInView(view)
        let pan = Double(((point.x / self.view.frame.width) * 2) - 1)
        Conductor.sharedInstance.barkLoudPanner.pan = pan
        gameEngine?.bark()
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        let point = gesture.locationInView(view)
        
        gameEngine?.moveDogToPoint(point.asFloat2)
    }
    
    var startingPosition: SCNVector3 = SCNVector3Zero
    func handlePinch(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Began {
            startingPosition = cameraNode.position
        }
        if gesture.state == .Changed {
            let zFar: Float = Float(cameraNode.camera?.zFar ?? 100.0)
            let buffer: Float = 10.0
            
            let startAxis = startingPosition.y
            var endAxis = startAxis + (startAxis - (startAxis * Float(gesture.scale)))
            endAxis = min(endAxis, zFar - buffer)
            endAxis = max(endAxis, buffer)
            cameraNode.position.y = endAxis
        }
    }
    
    //==========================================================================
    // MARK: - Models
    //==========================================================================
    
    func addBox(atPoint point: CGPoint) {
        let geometry = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.0)
        
        let node = SCNNode(geometry: geometry)
        node.position = convertPoint2Dto3D(point)
        scnView.scene?.rootNode.addChildNode(node)
        
        node.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
    }
    
    func addPyramid(atPoint point: CGPoint) {
        let geometry = SCNPyramid(width: 2.0, height: 2.0, length: 2.0)
        
        let node = SCNNode(geometry: geometry)
        node.position = convertPoint2Dto3D(point)
        scnView.scene?.rootNode.addChildNode(node)
        
        node.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
    }
    
    func createSheep(atPoint point: CGPoint) {
        let scene = SCNScene(named: "Sheep.dae")
        if let node = scene?.rootNode.childNodeWithName("sheep", recursively: true) {
            node.position = convertPoint2Dto3D(point)
        }
    }
    
    //==========================================================================
    // MARK: - Camera
    //==========================================================================
    
    lazy var cameraNode: SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x: 0, y: 25, z: 0)
        cameraNode.eulerAngles = SCNVector3(x: -Float(M_PI_2), y: 0.0, z: 0.0)
        
        return cameraNode
    }()
    
    //==========================================================================
    // MARK: - Labels
    //==========================================================================
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(36)
        label.textAlignment = .Left
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(36)
        label.textAlignment = .Right
        return label
    }()
    
    //==========================================================================
    // MARK: - Junk
    //==========================================================================
    
    func random(numberOfPoints count: Int, forSize size: CGSize) -> [CGPoint] {
        let inset = 64.0
        let useSize = CGSize(width: size.width - CGFloat(inset * 2.0), height: size.height - CGFloat(inset * 2.0))
        var points: [CGPoint] = []
        for _ in 0..<count {
            let point = CGPoint(x: Double(arc4random_uniform(UInt32(useSize.width))) + inset, y: Double(arc4random_uniform(UInt32(useSize.height))) + inset)
            print(point)
            
            points.append(point)
        }
        return points
    }
    
}
