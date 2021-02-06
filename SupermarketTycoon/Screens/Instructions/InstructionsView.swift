//
//  InstructionsView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 10/12/2020.
//

import SwiftUI


/// Shows instructions of the game.
struct InstructionsView: View {
    
    var body: some View {
        Image("Instructions")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}


struct InstructionsView_Previews: PreviewProvider {
    
    static var previews: some View {
        InstructionsView()
    }
}
