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
        
//        Conductor.sharedInstance.backgroundMusic.play()
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        let scene = SCNScene()
        
        // Set up the camera
        scene.rootNode.addChildNode(cameraNode)
        
        // This is a really lazy light source. But its kinda sun like...
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 25, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
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
        
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
//        view.addGestureRecognizer(pinchGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if gameEngine == nil {
            let mapSize = view.frame.size.asFloat2
            
            let dogPosition = CGPoint(x: view.frame.midX, y: view.frame.midY).asFloat2
            let sheepPositions = random(numberOfPoints: 3, forSize: view.frame.size).map {$0.asFloat2}
            
            let penCenter = CGPoint(x: view.frame.midX, y: 64.0).asFloat2
            let penSize = CGSize(width: 128, height: 128).asFloat2
            
            let pen = Pen(centerPoint: penCenter, rotation: 0.0, size: penSize)
            let map = Map(size: mapSize, dogPosition: dogPosition, sheepPositions: sheepPositions, pen: pen)
            
            gameEngine = GameEngine(map: map, displayDelegate: self)
            gameEngine?.scoreDelegate = self
            gameEngine?.load()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scnView.playing = true
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
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        let delta = lastTime != 0 ? time - lastTime : 0
        lastTime = time
        gameEngine?.update(delta)
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
            displayable = OurDisplayable(node: SCNNode(geometry: SCNSphere(radius: 0.5)))
        case .Pen(let size):
            print("The pen should be size:", size)
            displayable = OurDisplayable(node: SCNNode(geometry: SCNBox(width: 2.0, height: 0.1, length: 2.0, chamferRadius: 0.0)))
        case .Sheep:
            displayable = OurDisplayable(node: SCNNode(geometry: SCNPyramid(width: 1.0, height: 1.0, length: 1.0)))
        }
        
        displayable.delegate = self
        return displayable
    }
    
    //==========================================================================
    // MARK: - GameEngineDisplayDelegate
    //==========================================================================
    func scoreChanged(score: Int, totalPossible: Int) {
        print("Score changed to", score, "/", totalPossible)
    }
    
    //==========================================================================
    // MARK: - OurDisplayableDelegate
    //==========================================================================
    
    func convert3Dto2D(point: SCNVector3) -> CGPoint {
        let projectedPoint = scnView.projectPoint(point)
        
        return CGPoint(x: Double(projectedPoint.x), y: Double(projectedPoint.y))
    }
    
    func convert2Dto3D(point: CGPoint) -> SCNVector3 {
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
            touchedNode?.position = convert2Dto3D(point)
        }
    }
    
    func handleDoubleTap(gesture: UITapGestureRecognizer) {
//        gameEngine?.bark()
        let point = gesture.locationInView(view)
       
        if Conductor.sharedInstance.barkLoud.isPlaying {
            Conductor.sharedInstance.barkLoud.stop()
        }
        
        let pan = Double(((point.x / self.view.frame.width) * 2) - 1)
        Conductor.sharedInstance.barkLoudPanner.pan = pan
        Conductor.sharedInstance.barkLoud.play()
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
        node.position = convert2Dto3D(point)
        scnView.scene?.rootNode.addChildNode(node)
        
        node.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
    }
    
    func addPyramid(atPoint point: CGPoint) {
        let geometry = SCNPyramid(width: 2.0, height: 2.0, length: 2.0)
        
        let node = SCNNode(geometry: geometry)
        node.position = convert2Dto3D(point)
        scnView.scene?.rootNode.addChildNode(node)
        
        node.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
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
    // MARK: - Junk
    //==========================================================================
    
    func random(numberOfPoints count: Int, forSize size: CGSize) -> [CGPoint] {
        var points: [CGPoint] = []
        for _ in 0..<count {
            let point = CGPoint(x: Double(arc4random_uniform(UInt32(size.width))), y: Double(arc4random_uniform(UInt32(size.height))))
            print(point)
            
            points.append(point)
        }
        return points
    }
    
}
