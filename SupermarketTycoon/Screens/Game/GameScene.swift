//
//  GameScene.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SpriteKit


/// `SpriteKit` game scene.
class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        #warning("Temporary")
        let node = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
        node.position = CGPoint(x: 300, y: 200)
        addChild(node)
    }
}
