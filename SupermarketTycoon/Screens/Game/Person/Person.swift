//
//  Person.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 26/01/2021.
//

import SpriteKit


class Person {
    
    static let allNames: [String] = [
        // From top names list
        "Michael", "Christopher", "Matthew", "Joshua", "Jacob", "Nicholas", "Andrew", "Daniel", "Tyler", "Joseph",
        "Jessica", "Ashley", "Emily", "Sarah", "Amanda", "Elizabeth", "Taylor", "Megan", "Hannah", "Lauren"
    ]
    
    let node: SKSpriteNode
    var graphPosition: Int
    let name: String
    let shoppingList: [ShoppingItem]
    
    init(in graph: PathGraph) {
        graphPosition = 1
        name = Person.allNames.randomElement()!
        
        // Generate shopping list
        let itemIterator = Array(1 ... Int.random(in: 1 ... 5))
        shoppingList = itemIterator.map { _ in ShoppingItem() }
        
        // Create person node
        node = SKSpriteNode(imageNamed: "person_customer")
        node.position = graph.getNodeGroup(with: graphPosition).point
        node.zPosition = 2
    }
    
    /// Animate moving to a location by following a path.
    func move(along path: CGPath, to destination: Node, completion: @escaping () -> Void) {
        // Actions
        let walk = SKAction.follow(path, asOffset: false, orientToPath: false, speed: 70)
        
        node.run(walk) { [weak self] in
            guard let self = self else { return }
            self.graphPosition = destination.id
            completion()
        }
    }
}
