//
//  PathGraph.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 21/01/2021.
//

import CoreGraphics


/// Node holding the adjacent nodes.
struct NodeGroup {
    let id: Int
    let point: CGPoint
    let adjacent: [Int]
}


/// Paths represented as a graph of points connected in a triangular formation.
class PathGraph {
    
    static let nodeRange = 1 ... 28
    lazy var generation = GraphGeneration()
    private(set) var nodeGroups: [NodeGroup] = [
        NodeGroup(
            id: 1,
            point: CGPoint(x: 720, y: 30),
            adjacent: [10]
        ),
        NodeGroup(
            id: 2,
            point: CGPoint(x: 60, y: 545),
            adjacent: [8, 13]
        ),
        NodeGroup(
            id: 3,
            point: CGPoint(x: 437, y: 545),
            adjacent: [8, 9]
        ),
        NodeGroup(
            id: 4,
            point: CGPoint(x: 480, y: 545),
            adjacent: [9, 10]
        ),
        NodeGroup(
            id: 5,
            point: CGPoint(x: 960, y: 545),
            adjacent: [10, 11]
        ),
        NodeGroup(
            id: 6,
            point: CGPoint(x: 1003, y: 545),
            adjacent: [11, 12]
        ),
        NodeGroup(
            id: 7,
            point: CGPoint(x: 1380, y: 545),
            adjacent: [12, 22]
        ),
        NodeGroup(
            id: 8,
            point: CGPoint(x: 275, y: 600),
            adjacent: [2, 3, 9, 13, 14, 15, 16]
        ),
        NodeGroup(
            id: 9,
            point: CGPoint(x: 497.5, y: 600),
            adjacent: [3, 4, 8, 10, 16]
        ),
        NodeGroup(
            id: 10,
            point: CGPoint(x: 720, y: 600),
            adjacent: [1, 4, 5, 9, 11, 16, 17, 18, 19]
        ),
        NodeGroup(
            id: 11,
            point: CGPoint(x: 942.5, y: 600),
            adjacent: [5, 6, 10, 12, 19]
        ),
        NodeGroup(
            id: 12,
            point: CGPoint(x: 1165, y: 600),
            adjacent: [6, 7, 11, 19, 20, 21, 22]
        ),
        NodeGroup(
            id: 13,
            point: CGPoint(x: 100, y: 680),
            adjacent: [2, 8, 14, 23]
        ),
        NodeGroup(
            id: 14,
            point: CGPoint(x: 200, y: 690),
            adjacent: [8, 13, 23]
        ),
        NodeGroup(
            id: 15,
            point: CGPoint(x: 350, y: 690),
            adjacent: [8, 16, 24]
        ),
        NodeGroup(
            id: 16,
            point: CGPoint(x: 497.5, y: 680),
            adjacent: [8, 9, 10, 15, 17, 24, 25]
        ),
        NodeGroup(
            id: 17,
            point: CGPoint(x: 645, y: 690),
            adjacent: [10, 16, 25]
        ),
        NodeGroup(
            id: 18,
            point: CGPoint(x: 795, y: 690),
            adjacent: [10, 19, 26]
        ),
        NodeGroup(
            id: 19,
            point: CGPoint(x: 942.5, y: 680),
            adjacent: [10, 11, 12, 18, 20, 26, 27]
        ),
        NodeGroup(
            id: 20,
            point: CGPoint(x: 1090, y: 690),
            adjacent: [12, 19, 27]
        ),
        NodeGroup(
            id: 21,
            point: CGPoint(x: 1240, y: 690),
            adjacent: [12, 22, 28]
        ),
        NodeGroup(
            id: 22,
            point: CGPoint(x: 1340, y: 680),
            adjacent: [7, 12, 21, 28]
        ),
        NodeGroup(
            id: 23,
            point: CGPoint(x: 200, y: 790),
            adjacent: [13, 14]
        ),
        NodeGroup(
            id: 24,
            point: CGPoint(x: 350, y: 790),
            adjacent: [15, 16, 25]
        ),
        NodeGroup(
            id: 25,
            point: CGPoint(x: 645, y: 790),
            adjacent: [16, 17, 24]
        ),
        NodeGroup(
            id: 26,
            point: CGPoint(x: 795, y: 790),
            adjacent: [18, 19, 27]
        ),
        NodeGroup(
            id: 27,
            point: CGPoint(x: 1090, y: 790),
            adjacent: [19, 20, 26]
        ),
        NodeGroup(
            id: 28,
            point: CGPoint(x: 1240, y: 790),
            adjacent: [21, 22]
        )
    ]
    
    init() {
        nodeGroups = nodeGroups.map {
            NodeGroup(id: $0.id, point: Scaling.point($0.point), adjacent: $0.adjacent)
        }
    }
    
    /// Get the group associated with a specific `id`.
    /// - Parameter id: ID of `NodeGroup` to get.
    /// - Returns: `NodeGroup` with the given `id`.
    func getNodeGroup(with id: Int) -> NodeGroup {
        guard PathGraph.nodeRange ~= id else {
            fatalError("NodeGroup with id '\(id)' doesn't exist.")
        }
        let nodeGroup = nodeGroups[id - 1]
        guard nodeGroup.id == id else {
            fatalError("NodeGroup with id '\(nodeGroup.id)' did not match id '\(id)'.")
        }
        
        return nodeGroup
    }
}
