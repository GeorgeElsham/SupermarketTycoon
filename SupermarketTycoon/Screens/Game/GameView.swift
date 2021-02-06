//
//  GameView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SpriteKit
import SwiftUI


/// Main game screen.
struct GameView: View {
    
    @State private var selection: Upgrade = .advertising
    
    static let scene: GameScene = {
        let gameScene = GameScene(size: CGSize(width: 1440, height: 900))
        gameScene.view?.ignoresSiblingOrder = true
        gameScene.scaleMode = .aspectFit
        return gameScene
    }()
    
    var body: some View {
        NavigationView {
            List {
                Text("Upgrades")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.vertical)
                    .padding(.bottom, 12)
                
                VStack(spacing: 0) {
                    ForEach(Upgrade.allCases) { upgradeType in
                        Text(upgradeType.rawValue)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .underline(if: selection == upgradeType)
                            .foregroundColor(.black)
                            .foregroundColor(selection == upgradeType ? Color.black : Color(white: 0.25))
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(5)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selection = upgradeType
                            }
                    }
                }
            }
            .background(Color("Grass"))
            
            GeometryReader { geo in
                ZStack {
                    // Game scene
                    SpriteView(scene: GameView.scene)
                    
                    // Green bars top and bottom
                    VStack {
                        Color("Grass")
                            .frame(height: geo.size.height / 2 - geo.size.width / 3.2 + 1)
                        
                        Spacer()
                        
                        Color("Grass")
                            .frame(height: barHeight(for: geo.size))
                    }
                }
            }
        }
    }
    
    private func barHeight(for size: CGSize) -> CGFloat {
        size.height / 2 - size.width / 3.2 + 1
    }
}
