//
//  GameScene.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SpriteKit


/// `SpriteKit` game scene.
class GameScene: SKScene {
    
    let debugMode: Bool = true
    private(set) var money: Int = 0
    private(set) var graph: PathGraph!
    var center: CGPoint {
        CGPoint(x: frame.midX, y: frame.midY)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        graph = PathGraph(sceneSize: size)
        setupAll()
        
        let person = Person(in: graph)
        addChild(person.node)
        
        if debugMode {
            displayGraph()
        }
    }
}
