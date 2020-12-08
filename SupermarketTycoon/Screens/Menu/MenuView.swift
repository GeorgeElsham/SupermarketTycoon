//
//  MenuView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 08/12/2020.
//

import SwiftUI


struct MenuView: View {
    
    var body: some View {
        ZStack {
            Image("Menu")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            VStack {
                HStack {
                    VStack(spacing: 50) {
                        LargeButton("Play") {
                            print("Play")
                        }
                        
                        LargeButton("Instructions") {
                            print("Instructions")
                        }
                        
                        LargeButton("Leader board") {
                            print("Leader board")
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
