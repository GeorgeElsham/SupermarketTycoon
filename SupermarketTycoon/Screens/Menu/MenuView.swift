//
//  MenuView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 08/12/2020.
//

import SwiftUI


/// Initial menu screen.
struct MenuView: View {
    
    @Binding private var state: AppState
    
    init(state: Binding<AppState>) {
        _state = state
    }
    
    var body: some View {
        AppView {
            ZStack {
                Image("Menu")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                VStack {
                    HStack {
                        VStack(spacing: 50) {
                            LargeButton("Play") {
                                print("Play")
                                state = .game
                            }
                            
                            LargeButton("Instructions") {
                                print("Instructions")
                                state = .instructions
                            }
                            
                            LargeButton("Leader board") {
                                print("Leader board")
                                state = .leaderBoard
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                    
                    Spacer()
                        .frame(height: 190)
                }
            }
        } sidebar: {
            Color("Grass")
        }
    }
}


struct MenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        MenuView(state: .constant(.menu))
    }
}
