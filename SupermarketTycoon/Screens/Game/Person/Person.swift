//
//  Person.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 26/01/2021.
//

import SpriteKit


// MARK: - C: Person
/// Customers walking around the store with a shopping list.
class Person {
    
    static let walkingSpeed: CGFloat = 70
    static let allNames: [String] = [
        // From top names list
        "Michael", "Christopher", "Matthew", "Joshua", "Jacob", "Nicholas", "Andrew", "Daniel", "Tyler", "Joseph",
        "Jessica", "Ashley", "Emily", "Sarah", "Amanda", "Elizabeth", "Taylor", "Megan", "Hannah", "Lauren"
    ]
    
    let name: String
    let shoppingList: [ShoppingItem]
    private(set) var graphPosition: Int
    private let node: SKNode
    private unowned var graph: PathGraph
    
    init(in graph: PathGraph) {
        self.graph = graph
        name = Person.allNames.randomElement()!
        graphPosition = 1
        
        // Generate shopping list
        let numberOfItemsInList = Int.random(in: 1 ... 5)
        var tempShoppingList = [ShoppingItem]()
        
        while tempShoppingList.count < numberOfItemsInList {
            let item = ShoppingItem()
            guard !tempShoppingList.contains(where: { $0.item == item.item }) else { continue }
            tempShoppingList.append(item)
        }
        shoppingList = tempShoppingList
        
        // Create person node wrapper so person can be offset
        node = SKNode()
        node.position = graph.getNodeGroup(with: graphPosition).point
        node.zPosition = ZPosition.person.rawValue
        
        // Create person node
        let personNode = SKSpriteNode(imageNamed: "person_customer")
        personNode.position.y = 45
        node.addChild(personNode)
        GameView.scene.addChild(node)
    }
    
    /// Animate moving to a location by following a path.
    func move(along path: CGPath, to destination: Node, completion: @escaping () -> Void) {
        // Actions
        let walk = SKAction.follow(path, asOffset: false, orientToPath: false, speed: Person.walkingSpeed)
        
        node.run(walk) { [weak self] in
            guard let self = self else { return }
            self.graphPosition = destination.id
            completion()
        }
    }
}


// MARK: Ext: Start shopping
extension Person {
    func startShopping() {
        shopForItem { [weak self] in
            guard let self = self else { return }
            
            // Shopped for every item
            self.node.removeFromParent()
            
            #warning("Make person go to checkouts.")
        }
    }
    
    private func shopForItem(completion: @escaping () -> Void) {
        // Get first item which has not been obtained
        guard let item = shoppingList.first(where: { !$0.isObtained }) else {
            // All the items have been obtained, done
            completion()
            return
        }
        
        // Get destination to get to this item
        guard let destination = item.item.nodes.randomElement() else {
            fatalError("The item has no destinations. Item: '\(item.item)'.")
        }
        
        // Path find to this destination
        graph.generation.pathFind(person: self, to: Node(id: destination)) {
            // Get this item
            for i in 1 ... item.quantityRequired {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                    item.getItem()
                    
                    // Go to next item if getting last item
                    guard i == item.quantityRequired else { return }
                    self.shopForItem(completion: completion)
                }
            }
        }
    }
}
