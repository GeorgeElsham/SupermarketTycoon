//
//  PathGraph.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 21/01/2021.
//

import CoreGraphics


/// Singular node with an `id`.
struct Node {
    let id: Int
}

/// Node holding the adjacent nodes.
struct NodeGroup {
    let id: Int
    let point: CGPoint
    let group: [Int]
    
    var adjacentNodes: [Node] {
        group.map { Node(id: $0) }
    }
}


/// Paths represented as a graph of points connected in a triangular formation.
class PathGraph {
    
    static let nodeRange = 1 ... 28
    lazy var generation = GraphGeneration(graph: self)
    private(set) var nodeGroups: [NodeGroup] = [
        NodeGroup(
            id: 1,
            point: CGPoint(x: 720, y: 30),
            group: [10]
        ),
        NodeGroup(
            id: 2,
            point: CGPoint(x: 60, y: 425),
            group: [8, 13]
        ),
        NodeGroup(
            id: 3,
            point: CGPoint(x: 437, y: 425),
            group: [8, 9]
        ),
        NodeGroup(
            id: 4,
            point: CGPoint(x: 480, y: 425),
            group: [9, 10]
        ),
        NodeGroup(
            id: 5,
            point: CGPoint(x: 960, y: 425),
            group: [10, 11]
        ),
        NodeGroup(
            id: 6,
            point: CGPoint(x: 1003, y: 425),
            group: [11, 12]
        ),
        NodeGroup(
            id: 7,
            point: CGPoint(x: 1380, y: 425),
            group: [12, 22]
        ),
        NodeGroup(
            id: 8,
            point: CGPoint(x: 275, y: 600),
            group: [2, 3, 9, 13, 14, 15, 16]
        ),
        NodeGroup(
            id: 9,
            point: CGPoint(x: 497.5, y: 600),
            group: [3, 4, 8, 10, 16]
        ),
        NodeGroup(
            id: 10,
            point: CGPoint(x: 720, y: 600),
            group: [1, 4, 5, 9, 11, 16, 17, 18, 19]
        ),
        NodeGroup(
            id: 11,
            point: CGPoint(x: 942.5, y: 600),
            group: [5, 6, 10, 12, 19]
        ),
        NodeGroup(
            id: 12,
            point: CGPoint(x: 1165, y: 600),
            group: [6, 7, 11, 19, 20, 21, 22]
        ),
        NodeGroup(
            id: 13,
            point: CGPoint(x: 100, y: 700),
            group: [2, 8, 14, 23]
        ),
        NodeGroup(
            id: 14,
            point: CGPoint(x: 200, y: 710),
            group: [8, 13, 23]
        ),
        NodeGroup(
            id: 15,
            point: CGPoint(x: 350, y: 710),
            group: [8, 16, 24]
        ),
        NodeGroup(
            id: 16,
            point: CGPoint(x: 497.5, y: 700),
            group: [8, 9, 10, 15, 17, 24, 25]
        ),
        NodeGroup(
            id: 17,
            point: CGPoint(x: 645, y: 710),
            group: [10, 16, 25]
        ),
        NodeGroup(
            id: 18,
            point: CGPoint(x: 795, y: 710),
            group: [10, 19, 26]
        ),
        NodeGroup(
            id: 19,
            point: CGPoint(x: 942.5, y: 700),
            group: [10, 11, 12, 18, 20, 26, 27]
        ),
        NodeGroup(
            id: 20,
            point: CGPoint(x: 1090, y: 710),
            group: [12, 19, 27]
        ),
        NodeGroup(
            id: 21,
            point: CGPoint(x: 1240, y: 710),
            group: [12, 22, 28]
        ),
        NodeGroup(
            id: 22,
            point: CGPoint(x: 1340, y: 700),
            group: [7, 12, 21, 28]
        ),
        NodeGroup(
            id: 23,
            point: CGPoint(x: 200, y: 810),
            group: [13, 14]
        ),
        NodeGroup(
            id: 24,
            point: CGPoint(x: 350, y: 810),
            group: [15, 16, 25]
        ),
        NodeGroup(
            id: 25,
            point: CGPoint(x: 645, y: 810),
            group: [16, 17, 24]
        ),
        NodeGroup(
            id: 26,
            point: CGPoint(x: 795, y: 810),
            group: [18, 19, 27]
        ),
        NodeGroup(
            id: 27,
            point: CGPoint(x: 1090, y: 810),
            group: [19, 20, 26]
        ),
        NodeGroup(
            id: 28,
            point: CGPoint(x: 1240, y: 810),
            group: [21, 22]
        )
    ]
    
    init() {
        nodeGroups = nodeGroups.map {
            NodeGroup(id: $0.id, point: scaledPoint($0.point), group: $0.group)
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
    
    /// Scale a point to fit the game scene.
    func scaledPoint(_ point: CGPoint) -> CGPoint {
        point.scale(toFit: Global.scene!.size)
    }
}


private extension CGPoint {
    
    /// Scales coordinates of the standard scene size to fit the whole scene size.
    /// - Parameter size: Size of scene.
    /// - Returns: New scaled point.
    func scale(toFit size: CGSize) -> CGPoint {
        let originalSize = CGSize(width: 1440, height: 900)
        let ratio = size.width / originalSize.width
        let newSize = CGPoint(x: x * ratio, y: y * ratio)
        return newSize
    }
}
