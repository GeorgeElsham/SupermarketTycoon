//
//  GameScene-setup.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 15/01/2021.
//

import SpriteKit


extension GameScene {
    
    func setupAll() {
        // Scene view settings
        view?.ignoresSiblingOrder = true
        view?.shouldCullNonVisibleNodes = false
        if Global.debugMode {
            view?.showsFPS = true
            view?.showsNodeCount = true
            view?.showsDrawCount = true
        }
        
        // Initialize graph
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
        // Main background
        let bg = SKSpriteNode(imageNamed: "Game")
        bg.position = center
        bg.zPosition = ZPosition.background.rawValue
        bg.size = size
        addChild(bg)
        
        // Store front
        let front = SKSpriteNode(imageNamed: "Game_front")
        front.position = CGPoint(x: frame.midX, y: frame.minY + 135.5)
        front.zPosition = ZPosition.storeFront.rawValue
        front.size = CGSize(width: size.width + 2, height: size.height * 0.3)
        addChild(front)
    }
    
    private func setupMoney() {
        let moneyLabel = SKLabelNode(text: "Money:")
        moneyLabel.fontColor = .black
        moneyLabel.horizontalAlignmentMode = .left
        moneyLabel.fontName = "OpenSans-Semibold"
        moneyLabel.position = CGPoint(x: 50, y: 140)
        addChild(moneyLabel)
        
        // Current money/balance
        balanceLabel = SKLabelNode(text: gameInfo.formattedMoney)
        balanceLabel.fontColor = .black
        balanceLabel.horizontalAlignmentMode = .left
        balanceLabel.fontName = "OpenSans-Semibold"
        balanceLabel.position = CGPoint(x: 50, y: 80)
        addChild(balanceLabel)
    }
}
