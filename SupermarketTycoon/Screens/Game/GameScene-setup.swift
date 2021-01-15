//
//  GameScene-setup.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 15/01/2021.
//

import SpriteKit


extension GameScene {
    
    func setupAll() {
        setupBackground()
        setupMoney()
    }
    
    private func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "Game")
        bg.position = center
        bg.size = size
        addChild(bg)
    }
    
    private func setupMoney() {
        let moneyLabel = SKLabelNode(text: "Money:")
        moneyLabel.fontColor = .black
        moneyLabel.fontName = "OpenSans-Semibold"
        moneyLabel.position = CGPoint(x: 100, y: 160)
        addChild(moneyLabel)
        
        // Current money/balance
        let balLabel = SKLabelNode(text: "\(money)")
        balLabel.fontColor = .black
        balLabel.fontName = "OpenSans-Semibold"
        balLabel.position = CGPoint(x: 100, y: 80)
        addChild(balLabel)
    }
}
