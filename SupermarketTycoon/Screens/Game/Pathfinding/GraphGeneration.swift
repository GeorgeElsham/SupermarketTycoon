//
//  GraphGeneration.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 26/01/2021.
//

import GameKit


// MARK: - C: GraphGeneration
class GraphGeneration {
    
    private static let pathCurveSize: CGFloat = 80
    unowned private var graph: PathGraph
    
    init(graph: PathGraph) {
        self.graph = graph
    }
    
    // MARK: Regular pathfinding
    /// Path-find from the current position of the `customer` passed in, to a `destination` node.
    ///
    /// This algorithm is based on Dijkstra's algorithm. Link: https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
    ///
    /// - Parameters:
    ///   - customer: Customer to move.
    ///   - destination: Destination to move the customer to.
    ///   - completion: Completion handler to run after moving to the destination.
    func pathFind(customer: Customer, to destination: Int, completion: @escaping () -> Void = {}) {
        // Mark all nodes unvisited and set the initial node
        let allNodes: [NodeInfo] = PathGraph.nodeRange.map(NodeInfo.init)
        var unvisitedNodes: Set<NodeInfo> = Set(allNodes)
        var current: NodeInfo = unvisitedNodes[id: customer.graphPosition]!
        
        // Set initial node distance and values
        current.distance = 0
        var searchingPath = true
        var overflow = [[NodeInfo]]()
        
        // Repeat until the path is found
        while searchingPath {
            // Adjacent distances
            let adjacentIds = graph.getNodeGroup(with: current.id).adjacent
            var adjacentNodes = [NodeInfo]()
            
            for adjacentId in adjacentIds {
                // Get adjacent node
                guard let adjacentNode = unvisitedNodes[id: adjacentId] else { continue }
                adjacentNodes.append(adjacentNode)
                
                // Calculate distance
                let currentPoint = graph.getNodeGroup(with: current.id).point
                let adjacentPoint = graph.getNodeGroup(with: adjacentId).point
                let newDistance = current.distance + currentPoint.difference(to: adjacentPoint).distance
                
                // Set minimum distance
                if newDistance < adjacentNode.distance {
                    adjacentNode.distance = newDistance
                    adjacentNode.closestIdToHere = current.id
                }
            }
            
            // Mark as visited
            current.isUnvisited = false
            unvisitedNodes.remove(current)
            
            let potentialDestination = unvisitedNodes[id: destination]
            if potentialDestination == nil || !potentialDestination!.isUnvisited {
                // Finished
                searchingPath = false
            } else {
                // Go to nearest unvisited node
                let nearUnvisitedNodes = adjacentNodes.filter(\.isUnvisited).sorted(by: <)
                
                // Go into overflow
                if nearUnvisitedNodes.isEmpty {
                    let lastAdded = overflow[overflow.count - 1].removeFirst()
                    if overflow.last?.isEmpty == true {
                        overflow.removeLast()
                    }
                    current = allNodes.first(where: { $0.id == lastAdded.id })!
                    continue
                }
                
                // Add to overflow
                overflow.append(nearUnvisitedNodes)
                
                // Change current node or finish
                guard let closestUnvisited = adjacentNodes.filter(\.isUnvisited).closest else {
                    searchingPath = false
                    break
                }
                overflow[overflow.count - 1].remove(at: overflow.last!.firstIndex(of: closestUnvisited)!)
                if overflow.last?.isEmpty == true {
                    overflow.removeLast()
                }
                current = closestUnvisited
            }
        }
        
        // Move customer
        generatePointsAndMove(customer: customer, to: destination, allNodes: allNodes, completion: completion)
    }
    
    // MARK: Checkout pathfinding
    /// Same pathfinding as `pathFind(customer:to:completion:)`. However, this version looks for
    /// every available checkout, meaning that this pathfinding looks for multiple destinations. It can then
    /// determine the closest checkout to the current position.
    ///
    /// - Parameters:
    ///   - customer: Customer to move.
    ///   - available: Destination to move the customer to.
    ///   - completion: Completion handler to run after moving to the destination. Parameter is checkout index.
    func pathFindToNearestCheckout(customer: Customer, available: Int, completion: @escaping (Int) -> Void) {
        // Mark all nodes unvisited and set the initial node
        let allNodes: [NodeInfo] = PathGraph.nodeRange.map(NodeInfo.init)
        var unvisitedNodes: Set<NodeInfo> = Set(allNodes)
        var current: NodeInfo = unvisitedNodes[id: customer.graphPosition]!
        
        // Set initial node distance and values
        current.distance = 0
        var searchingPath = true
        var overflow = [[NodeInfo]]()
        
        var closest: (distance: CGFloat, node: Int) = (.infinity, 0)
        
        for destination in 2 ... available - 1 {
            // Repeat until the path is found
            while searchingPath {
                // Adjacent distances
                let adjacentIds = graph.getNodeGroup(with: current.id).adjacent
                var adjacentNodes = [NodeInfo]()
                
                for adjacentId in adjacentIds {
                    // Get adjacent node
                    guard let adjacentNode = unvisitedNodes[id: adjacentId] else { continue }
                    adjacentNodes.append(adjacentNode)
                    
                    // Calculate distance
                    let currentPoint = graph.getNodeGroup(with: current.id).point
                    let adjacentPoint = graph.getNodeGroup(with: adjacentId).point
                    let newDistance = current.distance + currentPoint.difference(to: adjacentPoint).distance
                    
                    // Set minimum distance
                    if newDistance < adjacentNode.distance {
                        adjacentNode.distance = newDistance
                        adjacentNode.closestIdToHere = current.id
                    }
                }
                
                // Mark as visited
                current.isUnvisited = false
                unvisitedNodes.remove(current)
                
                let potentialDestination = unvisitedNodes[id: destination]
                if potentialDestination == nil || !potentialDestination!.isUnvisited {
                    // Finished
                    searchingPath = false
                } else {
                    // Go to nearest unvisited node
                    let nearUnvisitedNodes = adjacentNodes.filter(\.isUnvisited).sorted(by: <)
                    
                    // Go into overflow
                    if nearUnvisitedNodes.isEmpty {
                        let lastAdded = overflow[overflow.count - 1].removeFirst()
                        if overflow.last?.isEmpty == true {
                            overflow.removeLast()
                        }
                        current = allNodes.first(where: { $0.id == lastAdded.id })!
                        continue
                    }
                    
                    // Add to overflow
                    overflow.append(nearUnvisitedNodes)
                    
                    // Change current node or finish
                    guard let closestUnvisited = adjacentNodes.filter(\.isUnvisited).closest else {
                        searchingPath = false
                        break
                    }
                    overflow[overflow.count - 1].remove(at: overflow.last!.firstIndex(of: closestUnvisited)!)
                    if overflow.last?.isEmpty == true {
                        overflow.removeLast()
                    }
                    current = closestUnvisited
                }
            }
            
            // Generate path
            current = allNodes[id: destination]!
            var fullPath: [NodeInfo] = [current]
            while let shortestRoute = current.closestIdToHere {
                current = allNodes[id: shortestRoute]!
                fullPath.append(current)
            }
            fullPath.reverse()
            
            // Convert to smooth path
            let pathPoints = fullPath.map { graph.getNodeGroup(with: $0.id).point }
            
            var totalDistance: CGFloat = 0
            for (index, point) in pathPoints.enumerated() {
                guard index != 0 else { continue }
                totalDistance += pathPoints[index - 1].difference(to: point).distance
            }
            
            // Save info if closest so far
            if totalDistance < closest.distance {
                closest = (totalDistance, destination)
            }
        }
        
        // Move customer
        generatePointsAndMove(customer: customer, to: closest.node, allNodes: allNodes) {
            completion(Checkout.indexOfCheckout(at: closest.node))
        }
    }
}


// MARK: Ext: Generate paths
extension GraphGeneration {
    /// Generates the path by backtracking through the closest routes.
    /// - Parameters:
    ///   - customer: Customer to move.
    ///   - destination: Destination to move the customer to.
    ///   - allNodes: Information about all the nodes in the graph, such as if it has been visited.
    ///   - completion: Completion handler to run after moving to the destination.
    private func generatePointsAndMove(customer: Customer, to destination: Int, allNodes: [NodeInfo], completion: @escaping () -> Void) {
        // Generate path
        var current = allNodes[id: destination]!
        var fullPath: [NodeInfo] = [current]
        while let shortestRoute = current.closestIdToHere {
            current = allNodes[id: shortestRoute]!
            fullPath.append(current)
        }
        fullPath.reverse()
        
        // Convert to smooth path
        let pathPoints = fullPath.map { graph.getNodeGroup(with: $0.id).point }
        let smoothPath = generatePath(from: pathPoints)
        
        // Make customer walk along path
        customer.move(along: smoothPath, to: destination) {
            completion()
        }
    }
    
    /// Generates a smooth path from a series of points. Makes
    /// walking look more natural as there are no sharp turns.
    private func generatePath(from points: [CGPoint]) -> CGMutablePath {
        // Make sure the path is a valid path-finding solution
        guard let firstPoint = points.first else {
            fatalError("Solution path is empty.")
        }
        
        let path = CGMutablePath()
        path.move(to: firstPoint)
        
        if points.count == 2 {
            // Simple path
            path.addLine(to: points[1])
        } else {
            // Complex path
            var lastPoint = points.first!
            
            for (index, thisPoint) in points.enumerated() {
                guard index != 0 else { continue }
                guard index < points.count - 1 else { break }
                
                // Connect line from last point to just before current point
                let vector = lastPoint.difference(to: thisPoint)
                let unitVector = vector.unitVector
                let newVector = unitVector.scale(by: vector.distance - min(GraphGeneration.pathCurveSize, vector.distance))
                let newPoint = lastPoint.offset(by: newVector)
                path.addLine(to: newPoint)
                
                // Curve round current point towards next point
                let vector2 = thisPoint.difference(to: points[index + 1])
                let unitVector2 = vector2.unitVector
                let newVector2 = unitVector2.scale(by: min(GraphGeneration.pathCurveSize, vector2.distance))
                let newPoint2 = thisPoint.offset(by: newVector2)
                path.addQuadCurve(to: newPoint2, control: thisPoint)
                lastPoint = newPoint2
                
                // Last iteration
                if index == points.count - 2 {
                    path.addLine(to: points[index + 1])
                }
            }
        }
        
        // Return newly generated path
        return path
    }
}



// MARK: C: NodeInfo
class NodeInfo: Equatable, Hashable, Comparable {
    
    let id: Int
    var isUnvisited: Bool
    var distance: CGFloat
    var closestIdToHere: Int?
    
    init(id: Int) {
        self.id = id
        isUnvisited = true
        distance = .infinity
        closestIdToHere = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NodeInfo, rhs: NodeInfo) -> Bool {
        lhs.id == rhs.id && lhs.isUnvisited == rhs.isUnvisited && lhs.distance == rhs.distance
    }
    
    static func < (lhs: NodeInfo, rhs: NodeInfo) -> Bool {
        lhs.distance < rhs.distance
    }
}



// MARK: - NodeInfo collection ext
extension Collection where Element == NodeInfo {
    subscript(id id: Int) -> NodeInfo? {
        first(where: { $0.id == id })
    }
    
    var closest: NodeInfo? {
        self.min(by: <)
    }
}
