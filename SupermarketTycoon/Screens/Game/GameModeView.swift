//
//  GameModeView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 11/02/2021.
//

import SwiftUI


// MARK: - S: GameModeView
struct GameModeView: View {
    
    @EnvironmentObject private var state: AppState
    @ObservedObject private var outsideData = OutsideData()
    @State private var mode: GameMode?
    
    var body: some View {
        if outsideData.hasEnded {
            VStack {
                Spacer()
                
                Text("You earned:")
                    .font(.custom("OpenSans-Semibold", size: 70))
                
                Spacer()
                    .frame(height: 50)
                
                Text("£\(outsideData.money)")
                    .font(.custom("OpenSans-Bold", size: 100))
                
                Spacer()
                    .frame(height: 150)
                
                LargeButton("Leader board") {
                    state.change(to: .leaderBoard)
                }
                
                Spacer()
                    .frame(height: 250)
                
                Spacer()
            }
            .foregroundColor(.black)
            .baseBackground()
        } else {
            if let mode = mode {
                GameView(mode: mode)
                    .environmentObject(outsideData)
            } else {
                HStack {
                    Spacer()
                    
                    ForEach(GameMode.allCases) { gameMode in
                        LargeButton(gameMode.rawValue) {
                            mode = gameMode
                        }
                        
                        Spacer()
                    }
                }
                .baseBackground()
                .frame(maxHeight: .infinity)
            }
        }
    }
}



// MARK: - E: GameMode
enum GameMode: String, CaseIterable, Identifiable {
    case endless = "Endless"
    case timed = "Timed"
    
    var id: String { rawValue }
}
