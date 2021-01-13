//
//  ViewController.swift
//  ARDicee
//
//  Created by Mateusz Sarnowski on 23/05/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Options for drawing overlay content to aid debugging of AR tracking in a SceneKit view -> Display a point cloud showing intermediate results of the scene analysis that ARKit uses to track device position.
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // A Boolean value that determines whether SceneKit automatically adds lights to a scene.
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/dice.scn")!
        
        // stworzenie punktu diceNode; recursively oznacza szukanie nazwy punktu po wszystkich poziomach
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(0, 0, -0.1)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // * class: A configuration that monitors the iOS device's position and orientation while enabling you to augment the environment that's in front of the user.
        let configuration = ARWorldTrackingConfiguration()
        
        // * var: A value that specifies if and how the session automatically attempts to detect flat surfaces in the camera-captured image.
        // * static var: horizontal: The session detects planar surfaces that are perpendicular to gravity.
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func rollAll() {
        // * var isEmpty: A Boolean value indicating whether the collection is empty.
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        // * var isEmpty: A Boolean value indicating whether the collection is empty.
        if !diceArray.isEmpty {
            for dice in diceArray {
                // * func removeFromParentNode(): Removes the node from its parent’s array of child nodes.
                dice.removeFromParentNode()
            }
        }
    }
    
    func roll(dice: SCNNode) {
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        // * func runAction(): Adds an action to the list of actions executed by the node.
        // * class SCNAction: A simple, reusable animation that changes attributes of any node you attach it to.
        // * clas func rotateBy(): Creates an action that rotates the node in each of the three principal axes by angles relative to its current orientation.
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // * class ARPlaneAnchor: A 2D surface that ARKit detects in the physical environment.
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let planeNode = createPlane(withPlaneAnchor: planeAnchor)
        
        // * func addChildNode: Adds a node to the node’s array of children.
        node.addChildNode(planeNode)
    }
    
    func createPlane(withPlaneAnchor planeAnchor: ARPlaneAnchor) -> SCNNode {
        // * class SCNPlane: A rectangular, one-sided plane geometry of specified width and height.
        // * var extent: The estimated width and length of the detected plane.
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        // * class SCNNode(): A structural element of a scene graph, representing a position and transform in a 3D coordinate space, to which you can attach geometry, lights, cameras, or other displayable content.
        let planeNode = SCNNode()
        
        // * var position: The translation applied to the node. Animatable.
        // * struct SCNVector3(): A representation of a three-component vector.
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        
        // * var transform: The transform applied to the node relative to its parent. Animatable.
        // * func SCNMatrix4MakeRotation: Returns a matrix describing a rotation transformation.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        // * class SCNMaterial: A set of shading attributes that define the appearance of a geometry's surface when rendered.
        let gridMaterial = SCNMaterial()
        
        // * var diffuse: An object that manages the material’s diffuse response to lighting.
        // * var contents: The visual contents of the material property—a color, image, or source of animated content. Animatable.
        // * class UIImage: An object that manages image data in your app.
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        // * var materials: An array of SCNMaterial objects that determine the geometry’s appearance when rendered.
        plane.materials = [gridMaterial]
        
        // * var geometry: The geometry attached to the node.
        planeNode.geometry = plane
        
        return planeNode
    }
    
    
    // Tells this object that one or more new touches occurred in a view or window.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // * var first: First element of the collection.
        if let touch = touches.first {
            // * func location: Returns the current location of the receiver in the coordinate system of the given view.
            let touchLocatiom = touch.location(in: sceneView)
            
            // * func hitTest: Searches for real-world objects or AR anchors in the captured camera image corresponding to a point in the SceneKit view.
            // * static var existingPlaneUsingExtent: A point on a real-world plane (already detected with the planeDetection option), respecting the plane's estimated size.
            let results = sceneView.hitTest(touchLocatiom, types: .existingPlaneUsingExtent)
            
            // * var first: First element of the collection.
            if let hitResults = results.first {
                addDice(atLocation: hitResults)
            }
        }
    }
    
    
    func addDice(atLocation location: ARHitTestResult) {
        // * class SCNScene: A container for the node hierarchy and global properties that together form a displayable 3D scene.
        let diceScene = SCNScene(named: "art.scnassets/dice.scn")!
        
        // * var rootNode: The root node of the scene graph.
        // * func childNode: Returns the first node in the node’s child node subtree with the specified name.
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(
                // * var worldTransform: The position and orientation of the hit test result relative to the world coordinate system.
                // * var columns: The columns of the matrix.
                location.worldTransform.columns.3.x,
                location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                location.worldTransform.columns.3.z
            )
            
            // * mutating func append: Adds an element to the end of the collection.
            diceArray.append(diceNode)
            
            // * var scene: The SceneKit scene to be displayed in the view.
            // * var rootNode: The root node of the scene graph.
            // * func addChildNode: Adds a node to the node’s array of children.
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
    }
    
    // Tells the receiver that a motion event has ended.
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    
    // DEFAULT FUNCTION
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    
    // DEFAULT FUNCTION
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    
    // DEFAULT FUNCTION
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}
