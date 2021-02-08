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
        // Render things in batches together for better performance
        let wholePath = CGMutablePath()
        let allNodes = SKNode()
        let allLabels = SKNode()
        
        // Generate nodes
        for nodeGroup in graph.nodeGroups {
            for adjacentNode in nodeGroup.adjacent {
                // Prevents lines between nodes being drawn twice
                guard adjacentNode < nodeGroup.id else { continue }
                
                // Create the lines
                let path = CGMutablePath()
                path.move(to: nodeGroup.point)
                path.addLine(to: graph.getNodeGroup(with: adjacentNode).point)
                wholePath.addPath(path)
            }
            
            // Create the node box
            let nodeBox = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 40))
            nodeBox.position = nodeGroup.point
            allNodes.addChild(nodeBox)
            
            // Create the label
            let pointLabel = SKLabelNode(text: String(nodeGroup.id))
            pointLabel.verticalAlignmentMode = .center
            pointLabel.position = nodeGroup.point
            allLabels.addChild(pointLabel)
        }
        
        // Add debug stuff to scene
        let line = SKShapeNode(path: wholePath)
        line.strokeColor = .red
        line.zPosition = ZPosition.debugLine.rawValue
        addChild(line)
        
        allNodes.zPosition = ZPosition.debugNode.rawValue
        addChild(allNodes)
        
        allLabels.zPosition = ZPosition.debugNodeLabel.rawValue
        addChild(allLabels)
    }
}
