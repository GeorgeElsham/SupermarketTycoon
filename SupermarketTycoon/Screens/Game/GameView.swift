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
    @State private var categorySelection: Category = .upgrades
    
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
                    Text("Supermarket Tycoon")
                        .bigTitle()
                        .padding(.vertical)
                        .padding(.bottom, 12)
                    
                    VStack(spacing: 0) {
                        ForEach(Category.allCases) { upgradeType in
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
                    
                    switch categorySelection {
                    case .upgrades:
                        UpgradesView()
                        
                    case .customer:
                        CustomerView(customer: outsideData.customerSelection)
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



// MARK: - E: Category
/// Different types of upgrades available.
enum Category: String, CaseIterable, Identifiable {
    case upgrades = "Upgrades"
    case customer = "Customer"
    
    var id: String { rawValue }
}



// MARK: - S: UpgradesView
struct UpgradesView: View {
    #warning("Complete `UpgradesView`.")
    var body: some View {
        BackgroundBox {
            Text("UPGRADES")
                .foregroundColor(.black)
        }
    }
}



// MARK: - S: CustomerView
/// Display information about customers.
struct CustomerView: View {
    
    private let customer: Customer?
    
    init(customer: Customer?) {
        self.customer = customer
    }
    
    var body: some View {
        if let customer = customer {
            BackgroundBox {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name:")
                        Text(customer.name)
                    }
                    .foregroundColor(.black)
                    
                    HStack {
                        Text("Age:")
                        Text(String(customer.age))
                    }
                    .foregroundColor(.black)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("Shopping list:")
                        .foregroundColor(.black)
                    
                    BackgroundBox {
                        VStack {
                            ForEach(customer.shoppingList, id: \.item) { shoppingItem in
                                HStack {
                                    Text(shoppingItem.item.name.plural)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text(String("x\(shoppingItem.quantityRequired)"))
                                        .foregroundColor(shoppingItem.color)
                                }
                                .frame(width: 200)
                            }
                        }
                    }
                }
            }
        } else {
            BackgroundBox {
                Text("No customer selected")
                    .foregroundColor(Color(white: 0.5))
            }
        }
    }
}
