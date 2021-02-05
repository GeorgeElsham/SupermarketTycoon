//
//  GameScene.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SpriteKit


/// `SpriteKit` game scene.
class GameScene: SKScene {
    
    private(set) var money: Int = 0
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


enum Settings {
    static let debugMode: Bool = true
    static var scene: GameScene?
    
    static func reset() {
        scene = nil
    }
}
