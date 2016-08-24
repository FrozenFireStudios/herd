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

class GameViewController: UIViewController {
    
    var scnView: SCNView {
        return view as! SCNView
    }
    
    override func loadView() {
        view = SCNView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Setup some Gestures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(pinchGesture)
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
    
    func handleTap(gesture: UITapGestureRecognizer) {
        let point = gesture.locationInView(view)
        addPyramid(atPoint: point)
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
    // MARK: - Coordinates
    //==========================================================================
    
    func convert2Dto3D(point: CGPoint) -> SCNVector3 {
        // The zeropoint for the z isn't actually even, so grab our origin.
        let projectedOrigin = scnView.projectPoint(SCNVector3Zero)
        
        // Convert to 3D with our x/y plus the origin z
        let touchPoint = SCNVector3(x: Float(point.x), y: Float(point.y), z: projectedOrigin.z)
        
        // unproject it to 3D space
        let convertedPoint = scnView.unprojectPoint(touchPoint)
        
        return convertedPoint
    }
}
