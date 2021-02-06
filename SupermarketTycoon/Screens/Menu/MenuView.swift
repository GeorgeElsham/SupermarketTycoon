//
//  MenuView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 08/12/2020.
//

import SwiftUI


/// Initial menu screen.
struct MenuView: View {
    
    @EnvironmentObject private var state: AppState
    
    var body: some View {
        ZStack {
            Image("Menu")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                HStack {
                    VStack(spacing: 50) {
                        LargeButton("Play") {
                            state.change(to: .game)
                        }
                        
                        LargeButton("Instructions") {
                            state.change(to: .instructions)
                        }
                        
                        LargeButton("Leader board") {
                            state.change(to: .leaderBoard)
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
    }
}


struct MenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        MenuView()
    }
}
