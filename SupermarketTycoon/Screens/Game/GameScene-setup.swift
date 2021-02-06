//
//  GameScene-setup.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 15/01/2021.
//

import SpriteKit


extension GameScene {
    
    func setupAll() {
        // Set globals
        Global.reset()
        Global.scene = self
        graph = PathGraph()
        
        // Show debug paths if in debug mode
        if Global.debugMode {
            displayGraph()
        }
        
        // Setup scene
        setupBackground()
        setupMoney()
        gameInfo.setup()
    }
    
    private func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "Game")
        bg.position = center
        bg.zPosition = ZPosition.background.rawValue
        bg.size = size
        addChild(bg)
    }
    
    private func setupMoney() {
        let moneyLabel = SKLabelNode(text: "Money:")
        moneyLabel.fontColor = .black
        moneyLabel.horizontalAlignmentMode = .left
        moneyLabel.fontName = "OpenSans-Semibold"
        moneyLabel.position = CGPoint(x: 50, y: 160)
        addChild(moneyLabel)
        
        // Current money/balance
        balanceLabel = SKLabelNode(text: gameInfo.formattedMoney)
        balanceLabel.fontColor = .black
        balanceLabel.horizontalAlignmentMode = .left
        balanceLabel.fontName = "OpenSans-Semibold"
        balanceLabel.position = CGPoint(x: 50, y: 100)
        addChild(balanceLabel)
    }
}
