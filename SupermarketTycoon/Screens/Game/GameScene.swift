//
//  GameScene.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SpriteKit


/// `SpriteKit` game scene.
class GameScene: SKScene {
    
    let gameInfo = GameInfo()
    var balanceLabel: SKLabelNode!
    var graph: PathGraph!
    var customers: [Person] = []
    
    var center: CGPoint {
        CGPoint(x: frame.midX, y: frame.midY)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Setup game
        setupAll()
        
        // Start game
        spawnCustomers()
    }
    
    /// Spawn customers forever.
    func spawnCustomers() {
        let customerSpawner = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.generateCustomer()
        }
        let pause = SKAction.wait(forDuration: 5, withRange: 3)
        let spawnPeriodically = SKAction.sequence([customerSpawner, pause])
        run(.repeatForever(spawnPeriodically))
    }
    
    /// Spawn customer at the door and make it start shopping.
    func generateCustomer() {
        let person = Person(in: graph)
        person.startShopping()
    }
}
