//
//  GameScene.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SpriteKit


/// `SpriteKit` game scene.
class GameScene: SKScene {
    
    var money: Int = 0
    var center: CGPoint {
        CGPoint(x: frame.midX, y: frame.midY)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupAll()
    }
}
