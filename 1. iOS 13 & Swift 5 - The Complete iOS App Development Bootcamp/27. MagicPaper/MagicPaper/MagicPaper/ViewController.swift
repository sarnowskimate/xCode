//
//  ViewController.swift
//  MagicPaper
//
//  Created by Mateusz Sarnowski on 28/05/2020.
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaperImages", bundle: .main) {
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images are being tracked")
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
            let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            videoNode.yScale = -1
            
            videoScene.addChild(videoNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -Float.pi / 2
            
            node.addChildNode(planeNode)
            
            
            
            for imageName in imagesArray {
                
                
//                    SKVideoNode(fileNamed: "harrypotter.mp4")
//                videoNode.position = CGPoint(x: frame.midX,
//                                          y: frame.midY)
//                addChild(sample)
//                sample.play()
                
                
                if imageAnchor.referenceImage.name == imageName {
//                    if let imageScene = SCNScene(named: "art.scnassets/\(pokeName).scn") {
//                        if let pokeNode = pokeScene.rootNode.childNodes.first {
//                            pokeNode.eulerAngles.x = Float.pi / 2
//
//                            planeNode.addChildNode(pokeNode)
//                        }
//                    }
                }
            }
        }
        return node
    }
    
    let imagesArray = ["harrypotter"]
}
