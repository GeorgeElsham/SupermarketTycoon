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
    var center: CGPoint {
        CGPoint(x: frame.midX, y: frame.midY)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupAll()
        
        let person = Person(in: graph)
        
        #warning("Temporary moving default person to show it works.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.graph.generation.pathFind(person: person, to: Node(id: 15)) {
                print("Completion")
            }
        }
    }
}
