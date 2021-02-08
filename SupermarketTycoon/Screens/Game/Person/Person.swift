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
    static let pickItemTime: Double = 1
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
    func move(along path: CGPath, to destination: Int, completion: @escaping () -> Void) {
        // Actions
        let walk = SKAction.follow(path, asOffset: false, orientToPath: false, speed: Person.walkingSpeed)
        
        node.run(walk) { [weak self] in
            guard let self = self else { return }
            self.graphPosition = destination
            completion()
        }
    }
    
    /// Customer walks from current position to door of store and leaves.
    func leaveStore() {
        // Make path
        let doors = graph.getNodeGroup(with: 1).point
        let path = CGMutablePath()
        path.move(to: node.position)
        path.addLine(to: doors)
        
        // Move
        let leave = SKAction.follow(path, asOffset: false, orientToPath: false, speed: Person.walkingSpeed)
        node.run(leave) {
            // Fade out and disappear
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            
            self.node.run(fadeOut) {
                self.node.removeFromParent()
            }
        }
    }
}


// MARK: Ext: Shopping
extension Person {
    /// Customer will shop for every item on their shopping list. After, they go to the checkouts, then leave.
    func startShopping(gameInfo: GameInfo) {
        shopForItem { [weak self] in
            guard let self = self else { return }
            
            // Shopped for every item, now pick best checkout
            let orderedCheckouts = gameInfo.checkouts.sorted(by: <)
            
            // Path find to checkout
            if orderedCheckouts.count == 1 || orderedCheckouts.first! < orderedCheckouts[1] {
                // Only 1 checkout, only thing to use
                // OR
                // Smallest queue, go to this checkout
                let checkout = orderedCheckouts.first!
                self.graph.generation.pathFind(person: self, to: checkout.node) {
                    #warning("Temporarily no queue")
                    checkout.addPersonToQueue(self)
                    checkout.processFirstInQueue()
                }
            } else {
                // Multiple checkouts with same queue length, pick nearest small queue
                self.graph.generation.pathFindToNearestCheckout(person: self, available: orderedCheckouts.count) { checkoutIndex in
                    #warning("Temporarily no queue")
                    let checkout = gameInfo.checkouts[checkoutIndex]
                    checkout.addPersonToQueue(self)
                    checkout.processFirstInQueue()
                }
            }
        }
    }
    
    /// Go to the shelf for this item to get. Get all items off the shelf in shopping
    /// list, then go to next item until shopping list is complete.
    /// - Parameter completion: Ran when shopping list is all obtained.
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
        graph.generation.pathFind(person: self, to: destination) {
            // Get this item
            for i in 1 ... item.quantityRequired {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * Person.pickItemTime) {
                    item.getItem()
                    self.pickedUpItemAnimation()
                    
                    // Go to next item if getting last item
                    guard i == item.quantityRequired else { return }
                    self.shopForItem(completion: completion)
                }
            }
        }
    }
    
    /// Show animation of customer picking up item off the shelf.
    private func pickedUpItemAnimation() {
        // Label node
        let plus1 = SKLabelNode(fontNamed: "OpenSans-Semibold")
        plus1.text = "+1"
        plus1.fontColor = .green
        plus1.fontSize = 25
        plus1.position = CGPoint(x: 45, y: 60)
        node.addChild(plus1)
        
        // Run animation action
        let rise = SKAction.moveBy(x: 0, y: 30, duration: 0.3)
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let fade = SKAction.sequence([fadeIn, .wait(forDuration: 0.1), fadeOut])
        let obtainAnim = SKAction.group([rise, fade])
        
        plus1.run(obtainAnim) {
            plus1.removeFromParent()
        }
    }
}
