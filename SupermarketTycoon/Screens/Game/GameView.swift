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
    
    var body: some View {
        AppView {
            GeometryReader { geo in
                SpriteView(scene: makeGameScene(size: geo.size))
            }
        } sidebar: {
            Color("Grass")
        }
    }
    
    private func makeGameScene(size: CGSize) -> GameScene {
        let scene = GameScene(size: size)
        scene.view?.ignoresSiblingOrder = true
        return scene
    }
}


struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView()
    }
}
