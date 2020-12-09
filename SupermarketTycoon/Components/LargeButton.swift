//
//  LargeButton.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 08/12/2020.
//

import SwiftUI


/// Large button used globally across the app.
struct LargeButton: View {
    
    private let title: String
    private let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Font.custom("OpenSans", size: 70).bold())
                .foregroundColor(.black)
                .frame(width: 500, height: 150)
                .background(Color("Button"))
                .cornerRadius(40)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct LargeButton_Previews: PreviewProvider {
    
    static var previews: some View {
        LargeButton("Title") {}
    }
}
