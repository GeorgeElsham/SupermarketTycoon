//
//  GameView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SpriteKit
import SwiftUI


// MARK: - S: GameView
/// Main game screen.
struct GameView: View {
    
    static var scene: GameScene!
    @ObservedObject private var outsideData = OutsideData()
    @State private var categorySelection: Upgrade = .advertising
    
    init() {
        // Remake scene
        let gameScene = GameScene(size: CGSize(width: 1440, height: 900), outsideData: outsideData)
        gameScene.scaleMode = .aspectFit
        GameView.scene = gameScene
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("Upgrades")
                        .bigTitle()
                        .padding(.vertical)
                        .padding(.bottom, 12)
                    
                    VStack(spacing: 0) {
                        ForEach(Upgrade.allCases) { upgradeType in
                            Text(upgradeType.rawValue)
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .underline(if: categorySelection == upgradeType)
                                .foregroundColor(.black)
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .cornerRadius(5)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    categorySelection = upgradeType
                                }
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                
                VStack(alignment: .leading) {
                    Text(categorySelection.rawValue)
                        .bigTitle()
                        .padding(.top)
                    
                    Text(categorySelection == .customer ? "Information" : "Upgrades")
                        .font(.largeTitle)
                        .foregroundColor(Color(white: 0.3))
                        .padding(.bottom, 12)
                    
                    BackgroundBox {
                        Text("Test: \(outsideData.customerSelection?.name ?? "-")")
                            .foregroundColor(.black)
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .padding()
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
                            .padding(.trailing, Global.debugMode ? 200 : 0)
                    }
                }
            }
        }
    }
    
    private func barHeight(for size: CGSize) -> CGFloat {
        size.height / 2 - size.width / 3.2 + 1
    }
}



// MARK: - C: OutsideData
class OutsideData: ObservableObject {
    @Published var customerSelection: Customer?
}
