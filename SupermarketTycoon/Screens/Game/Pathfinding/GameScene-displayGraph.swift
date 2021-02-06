//
//  GameScene-displayGraph.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 21/01/2021.
//

import SpriteKit


extension GameScene {
    
    /// Display all the paths customers can take.
    func displayGraph() {
        for nodeGroup in graph.nodeGroups {
            for adjacentNode in nodeGroup.adjacentNodes {
                // Prevents lines between nodes being drawn twice
                guard adjacentNode.id < nodeGroup.id else { continue }
                
                // Create the lines
                let path = CGMutablePath()
                path.move(to: nodeGroup.point)
                path.addLine(to: graph.getNodeGroup(with: adjacentNode.id).point)
                path.closeSubpath()
                
                let line = SKShapeNode(path: path)
                line.strokeColor = .red
                line.zPosition = ZPosition.debugLine.rawValue
                addChild(line)
            }
            
            // Create the labels
            let point = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 40))
            let pointLabel = SKLabelNode(text: String(nodeGroup.id))
            pointLabel.verticalAlignmentMode = .center
            point.addChild(pointLabel)
            point.position = nodeGroup.point
            point.zPosition = ZPosition.debugNode.rawValue
            addChild(point)
        }
    }
}
