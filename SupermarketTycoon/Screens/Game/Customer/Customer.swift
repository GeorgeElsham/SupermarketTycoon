//
//  Customer.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 26/01/2021.
//

import SpriteKit


// MARK: - C: Customer
/// Customers walking around the store with a shopping list.
class Customer {
    
    static let walkingSpeed: CGFloat = 100
    static let pickItemTime: Double = 1
    static let allNames: [String] = [
        // From top names list
        "Michael", "Christopher", "Matthew", "Joshua", "Jacob", "Nicholas", "Andrew", "Daniel", "Tyler", "Joseph",
        "Jessica", "Ashley", "Emily", "Sarah", "Amanda", "Elizabeth", "Taylor", "Megan", "Hannah", "Lauren"
    ]
    
    let name: String
    let age: Int
    let shoppingList: [ShoppingItem]
    private(set) var isAngry = false
    private(set) var graphPosition: Int
    private let node: SKNode
    private let basketNode: SKSpriteNode
    
    private var actualWalkingSpeed: CGFloat {
        Customer.walkingSpeed * (isAngry ? 1.3 : 1) * (GameView.scene.gameInfo.outsideData.speedBoost ? 2 : 1)
    }
    
    init() {
        name = Customer.allNames.randomElement()!
        age = Int.random(in: 20 ... 50)
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
        
        // Create customer node wrapper so customer can be offset
        node = SKNode()
        node.position = GameView.scene.graph.getNodeGroup(with: graphPosition).point
        node.zPosition = ZPosition.customer.rawValue
        
        // Give customer basket
        basketNode = SKSpriteNode(imageNamed: "basket-empty")
        basketNode.position = CGPoint(x: -14, y: 32)
        basketNode.zPosition = 0.01
        node.addChild(basketNode)
        
        // Create customer node
        let customerNode = SKSpriteNode(imageNamed: "person_customer")
        customerNode.name = "Customer"
        GameView.scene.gameInfo.customers.append(CustomerNodeGroup(node: customerNode, customer: self))
        customerNode.position.y = 45
        node.addChild(customerNode)
        GameView.scene.addChild(node)
        
        // Fade in
        node.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        node.run(fadeIn)
    }
    
    /// Animate moving to a location by following a path.
    func move(along path: CGPath, to destination: Int, completion: @escaping () -> Void) {
        // Move
        follow(path: path) { [weak self] in
            guard let self = self else { return }
            self.graphPosition = destination
            completion()
        }
    }
    
    /// Moves customer in the queue.
    /// - Parameters:
    ///   - index: Place in queue customer is at. Determines position it should be in.
    ///   - completion: Ran when moved to destination.
    func moveDownInQueue(to index: Int, completion: @escaping () -> Void) {
        let downPath = CGMutablePath()
        downPath.move(to: node.position)
        downPath.addLine(to: CGPoint(x: node.position.x, y: 405 + 70 * CGFloat(index)))
        follow(path: downPath, completion: completion)
    }
    
    /// Customer walks from current position to door of store and leaves.
    /// - Parameters:
    ///   - fromCheckouts: If leaving the store from the checkouts, the customer will walk further down past the checkout.
    ///   - completion: Ran when customer has got to doors and faded out.
    func leaveStore(fromCheckouts: Bool, completion: @escaping () -> Void = {}) {
        // Make path
        let doors = GameView.scene.graph.getNodeGroup(with: 1).point
        let points: [CGPoint]
        
        // Generate path
        if fromCheckouts {
            points = [
                node.position,
                node.position.offset(by: CGSize(width: 0, height: -100)),
                doors
            ]
        } else {
            let node10Point = GameView.scene.graph.getNodeGroup(with: 10).point
            
            points = [
                node.position,
                node10Point.offset(by: CGSize(width: .random(in: -70 ... 70), height: .random(in: -70 ... 0))),
                doors.offset(by: CGSize(width: .random(in: -30 ... 30), height: 0))
            ]
        }
        
        let path = GraphGeneration.generatePath(from: points)
        
        // Move
        follow(path: path) {
            // Fade out and disappear
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            self.node.run(fadeOut) {
                // Run completion
                completion()
                
                // Remove node from scene
                self.node.removeFromParent()
                
                // Remove from customers list so Person can be deallocated
                if GameView.scene.gameInfo.outsideData.customerSelection == self {
                    GameView.scene.gameInfo.outsideData.customerSelection = nil
                }
                guard let index = GameView.scene.gameInfo.customers.firstIndex(where: { $0.customer == self }) else { return }
                GameView.scene.gameInfo.customers.remove(at: index)
            }
        }
    }
    
    /// Node follows path.
    /// - Parameters:
    ///   - path: Path for customer to follow.
    ///   - completion: Ran when node has got to destination.
    private func follow(path: CGPath, completion: @escaping () -> Void) {
        // Actions
        let follow = SKAction.follow(path, asOffset: false, orientToPath: false, speed: actualWalkingSpeed)
        let zPos = SKAction.customAction(withDuration: 0.1) { [weak self] node, timeElapsed in
            guard let self = self else { return }
            let heightProp = self.node.position.y / GameView.scene.size.height
            self.node.zPosition = ZPosition.customer.rawValue - heightProp
        }
        
        // Run actions
        node.run(follow) {
            self.node.removeAction(forKey: "action-z_pos")
            completion()
        }
        node.run(.repeatForever(zPos), withKey: "action-z_pos")
    }
}


// MARK: Ext: Equatable
extension Customer: Equatable {
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        lhs.node == rhs.node
    }
}


// MARK: Ext: Shopping
extension Customer {
    /// Customer will shop for every item on their shopping list. After, they go to the checkouts, then leave.
    func startShopping() {
        shopForItem { [weak self] in
            guard let self = self else { return }
            
            // Shopped for every item, now pick best checkout
            let orderedCheckouts = GameView.scene.gameInfo.checkouts.sorted(by: <).filter({ $0.queue.count < 3 })
            
            // Make sure there are available checkouts
            guard !orderedCheckouts.isEmpty else {
                // Add angry image
                self.isAngry = true
                let angry = SKSpriteNode(imageNamed: "angry")
                angry.position.y = 125
                self.node.addChild(angry)
                
                // Leave
                self.leaveStore(fromCheckouts: false) {
                    angry.removeFromParent()
                }
                return
            }
            
            // Pick appropriate checkout
            if orderedCheckouts.count == 1 || orderedCheckouts.first! < orderedCheckouts[1] {
                // Only 1 checkout, only thing to use
                // OR
                // Smallest queue, go to this checkout
                let checkout = orderedCheckouts.first!
                try! checkout.reservePlaceInQueue(self)
                
                // Path-find
                GameView.scene.graph.generation.pathFind(customer: self, to: checkout.positions.node) {
                    try! checkout.addCustomerToQueue(self)
                }
            } else {
                // Multiple checkouts with same queue length, pick nearest small queue
                var checkout: Checkout!
                
                // Path-find
                GameView.scene.graph.generation.pathFindToNearestCheckout(
                    customer: self,
                    available: GameView.scene.gameInfo.checkouts.count
                ) { checkoutIndex in
                    checkout = GameView.scene.gameInfo.checkouts[checkoutIndex]
                    try! checkout.reservePlaceInQueue(self)
                } completion: { _ in
                    try! checkout.addCustomerToQueue(self)
                }
            }
        }
    }
    
    /// Trigger when customer arrives to checkout. Displays basket
    /// emptying and putting items on checkout.
    /// - Parameter side: Side of the checkout.
    func nowAtCheckout(side: Checkout.Side) {
        // Show empty basket
        basketNode.texture = SKTexture(imageNamed: "basket-empty")
        
        // Show items on belt
        let items = SKSpriteNode(imageNamed: "items")
        items.position = CGPoint(x: side == .left ? 57 : -57, y: 20)
        items.name = "Items"
        node.addChild(items)
    }
    
    /// Trigger when customer leaves checkout. Puts items back in basket.
    func nowLeftCheckout() {
        // Back to normal
        basketNode.texture = SKTexture(imageNamed: "basket-full")
        node.childNode(withName: "Items")?.removeFromParent()
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
        GameView.scene.graph.generation.pathFind(customer: self, to: destination) {
            // Get this item
            for i in 1 ... item.quantityRequired {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * Customer.pickItemTime) {
                    item.getItem()
                    self.pickedUpItemAnimation()
                    self.basketNode.texture = SKTexture(imageNamed: "basket-full")
                    
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
        plus1.run(obtainAnim, completion: plus1.removeFromParent)
    }
}


// MARK: Ext: Outline
extension Customer {
    func showOutline() {
        let outline = SKSpriteNode(imageNamed: "person_outline")
        outline.name = "Outline"
        outline.zPosition = 0.005
        node.childNode(withName: "Customer")?.addChild(outline)
    }
    func hideOutline() {
        let outline = node.childNode(withName: "Customer")?.childNode(withName: "Outline")
        outline?.removeFromParent()
    }
}



// MARK: - S: CustomerNodeGroup
struct CustomerNodeGroup {
    weak var node: SKSpriteNode?
    weak var customer: Customer?
    
    init(node: SKSpriteNode, customer: Customer) {
        self.node = node
        self.customer = customer
    }
}
