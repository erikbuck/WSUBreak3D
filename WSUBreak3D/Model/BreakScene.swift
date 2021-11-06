//
//  BreakScene.swift
//  WSUBreak3D
//
//  Created by wsucatslabs on 11/1/21.
//

import SceneKit

class BreakScene : SCNScene, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    var paddle : SCNNode?
    var ball : SCNNode?
    var ballSpawnPosition = SCNVector3Zero
    @objc var score = 0 {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("scoreDidChange"), object: self)
        }
    }
    
    func setup() {
        physicsWorld.contactDelegate = self
        paddle = rootNode.childNode(withName: "Paddle", recursively: true)
        ball = rootNode.childNode(withName: "Ball", recursively: true)
        ballSpawnPosition = ball!.position
    }
    
    func movePaddle(translation : CGPoint) {
        let newX = min(max(Float(translation.x), -180), 180) * 0.05
        paddle!.position = SCNVector3(newX, paddle!.position.y, 0)
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if(ball!.presentation.position.y < (paddle!.position.y - 70.0)) {
            ball!.position = ballSpawnPosition
            ball!.physicsBody?.velocity = SCNVector3Zero
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        if(nodeA == ball) {
            nodeB.removeFromParentNode()
            score += 1
        } else if(nodeB == ball) {
            nodeA.removeFromParentNode()
            score += 1
        }
    }
}
