//
//  ViewController.swift
//  Poke3D
//
//  Created by Mateusz Sarnowski on 27/05/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: .main) {
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = pokesArray.count
            
            print("Images succesfuly added.")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor.init(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -Float.pi / 2
            
            node.addChildNode(planeNode)
            
            for pokeName in pokesArray {
                if imageAnchor.referenceImage.name == "\(pokeName)-card" {
                    if let pokeScene = SCNScene(named: "art.scnassets/\(pokeName).scn") {
                        if let pokeNode = pokeScene.rootNode.childNodes.first {
                            pokeNode.eulerAngles.x = Float.pi / 2
                            
                            planeNode.addChildNode(pokeNode)
                        }
                    }
                }
            }
        }
        return node
    }
    
    let pokesArray = ["Eevee", "Oddish"]
}
