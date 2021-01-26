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
        for nodeGroup in PathGraph.nodeGroups {
            for adjacentNode in nodeGroup.adjacentNodes {
                // Prevents lines between nodes being drawn twice
                guard adjacentNode.id < nodeGroup.id else { continue }
                
                // Create the lines
                let path = CGMutablePath()
                path.move(to: nodeGroup.point.scale(toFit: size))
                path.addLine(to: PathGraph.getNodeGroup(with: adjacentNode.id).point.scale(toFit: size))
                path.closeSubpath()
                
                let line = SKShapeNode(path: path)
                line.strokeColor = .red
                line.zPosition = 1
                addChild(line)
            }
            
            // Create the labels
            let point = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 40))
            let pointLabel = SKLabelNode(text: String(nodeGroup.id))
            pointLabel.verticalAlignmentMode = .center
            point.addChild(pointLabel)
            point.position = nodeGroup.point.scale(toFit: size)
            point.zPosition = 1.1
            addChild(point)
        }
    }
}
