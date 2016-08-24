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
    
    var scnView: SCNView? {
        return view as? SCNView
    }
    
    override func loadView() {
        view = SCNView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set up the camera
        scene.rootNode.addChildNode(cameraNode)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 50, z: 0)
        cameraNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        scnView?.scene = scene
        scnView?.showsStatistics = true
        scnView?.backgroundColor = UIColor.greenColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(pinchGesture)
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        let point = gestureRecognize.locationInView(view)
        
        guard let scnView = scnView else {
            return
        }
        
        let hitResults = scnView.hitTest(point, options: nil)
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
        else {
            let boxGeometry = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.0)
            
            // The zeropoint for the z isn't actually even, so grab our origin.
            let projectedOrigin = scnView.projectPoint(SCNVector3Zero)
            let touchPoint = SCNVector3(x: Float(point.x), y: Float(point.y), z: projectedOrigin.z)
            let convertedPoint = scnView.unprojectPoint(touchPoint)
            
            let box = SCNNode(geometry: boxGeometry)
            box.position = convertedPoint
            scnView.scene?.rootNode.addChildNode(box)
            
            box.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(2, y: 2, z: 2, duration: 1)))
        }
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
    // MARK: - Camera
    //==========================================================================
    
    lazy var cameraNode: SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
//        cameraNode.eulerAngles = SCNVector3(x: -Float(M_PI_2), y: 0.0, z: 0.0)
        
        return cameraNode
    }()
    
    var startingPosition: SCNVector3 = SCNVector3Zero
    func handlePinch(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Began {
            startingPosition = cameraNode.position
        }
        if gesture.state == .Changed {
            let zFar: Float = Float(cameraNode.camera?.zFar ?? 100.0)
            let buffer: Float = 10.0
            
            let startPoint = startingPosition.z
            var z = startPoint + (startPoint - (startPoint * Float(gesture.scale)))
            z = min(z, zFar - buffer)
            z = max(z, buffer)
            cameraNode.position.z = z
        }
    }
}
