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
        setupTimer()
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
        moneyLabel.zPosition = ZPosition.storeFront.rawValue + 0.1
        addChild(moneyLabel)
        
        // Current money/balance
        balanceLabel = SKLabelNode(text: gameInfo.formattedMoney)
        balanceLabel.fontColor = .black
        balanceLabel.horizontalAlignmentMode = .left
        balanceLabel.fontName = "OpenSans-Semibold"
        balanceLabel.position = CGPoint(x: 50, y: 80)
        balanceLabel.zPosition = ZPosition.storeFront.rawValue + 0.1
        addChild(balanceLabel)
    }
    
    private func setupTimer() {
        // Make sure in timed mode
        guard mode == .timed else { return }
        
        // Timer label
        timerLabel = SKLabelNode(text: "3:00")
        timerLabel.fontColor = .black
        timerLabel.horizontalAlignmentMode = .left
        timerLabel.fontName = "OpenSans-Bold"
        timerLabel.position = CGPoint(x: 50, y: size.height - 80)
        timerLabel.zPosition = ZPosition.storeFront.rawValue + 0.1
        addChild(timerLabel)
        
        // Start timer
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer)
    }
    
    private func updateTimer(_ timer: Timer) {
        // Change time
        if gameInfo.time.s == 0 {
            gameInfo.time = (gameInfo.time.m - 1, 59)
        } else {
            gameInfo.time.s -= 1
        }
        
        // Update timer label
        timerLabel.text = "\(gameInfo.time.m):\(String(format: "%02d", gameInfo.time.s))"
    }
}
