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
                SpriteView(scene: GameScene(size: geo.size))
            }
        } sidebar: {
            Color("Grass")
        }
    }
}


struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView()
    }
}
