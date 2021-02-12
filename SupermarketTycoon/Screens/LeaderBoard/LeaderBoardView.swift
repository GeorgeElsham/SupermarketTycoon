//
//  LeaderBoardView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 11/02/2021.
//

import SwiftUI


// MARK: - S: LeaderBoardView
/// Displays leaderboard of top 10 scores.
struct LeaderBoardView: View {
    
    struct ScoreItem: Identifiable {
        let rank: String
        let name: String
        let money: String
        var id: String { rank }
        
        var rankColor: Color {
            switch rank {
            case "1st":     return .init(red: 0.97, green: 0.76, blue: 0.00)
            case "2nd":     return .init(red: 0.80, green: 0.82, blue: 0.69)
            case "3rd":     return .init(red: 0.78, green: 0.45, blue: 0.00)
            default:        return .black
            }
        }
        
        init(item: (Int, Score)) {
            rank = ScoreItem.getRank(for: item.0)
            name = item.1.name!
            money = "£\(String(item.1.money))"
        }
        
        static func getRank(for index: Int) -> String {
            switch index {
            case 0:     return "1st"
            case 1:     return "2nd"
            case 2:     return "3rd"
            default:    return "\(index + 1)th"
            }
        }
    }
    
    static let scoresRequest: NSFetchRequest<Score> = {
        let request: NSFetchRequest<Score> = Score.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Score.money, ascending: false)]
        return request
    }()
    
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(fetchRequest: scoresRequest) private var scores: FetchedResults<Score>
    
    var scoreItems: [ScoreItem] {
        scores.prefix(10).enumerated().map(ScoreItem.init)
    }
    var bestScore: ScoreItem? {
        // Get personal best
        let currentFiltered = scores.filter({ $0.name == "Player" }).sorted(by: >)
        guard !currentFiltered.isEmpty else { return nil }
        
        // Get ScoreItem
        let currentIndex = scores.firstIndex(of: currentFiltered.first!)!
        return ScoreItem(item: (currentIndex, scores[currentIndex]))
    }
    
    var body: some View {
        ZStack {
            Image("Leader-board")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            BackgroundBox {
                VStack(spacing: 8) {
                    HStack {
                        Text("Rank")
                            .frame(width: 150)
                        
                        Spacer()
                            .frame(width: 100)
                        
                        Text("Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Score")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundColor(.black)
                    .font(.custom("OpenSans-Bold", size: 25))
                    .overlay(
                        // Simulate adding/removing scores
                        Global.debugMode ?
                            HStack {
                                Button("Add") {
                                    let score = Score(context: moc)
                                    score.name = Int.random(in: 1 ... 5) == 1 ? "Player" : Customer.allNames.randomElement()!
                                    score.money = Int64.random(in: 1 ... 1000)
                                    try? moc.save()
                                }
                                
                                Button("Clear") {
                                    scores.forEach { moc.delete($0) }
                                }
                            }
                        : nil
                    )
                    
                    Spacer()
                        .frame(height: 12)
                    
                    ForEach(scoreItems) { scoreItem in
                        HStack {
                            Text(scoreItem.rank)
                                .foregroundColor(scoreItem.rankColor)
                                .frame(width: 150)
                            
                            Spacer()
                                .frame(width: 100)
                            
                            Text(scoreItem.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.black)
                            
                            Text(scoreItem.money)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.black)
                        }
                    }
                    .font(.custom("OpenSans-Semibold", size: 25))
                    
                    Spacer(minLength: 0)
                        .layoutPriority(1)
                    
                    if let bestScore = bestScore {
                        BackgroundBox {
                            HStack {
                                Text(bestScore.rank)
                                    .foregroundColor(bestScore.rankColor)
                                    .frame(width: 150)
                                    .padding(.leading, -18)
                                
                                Spacer()
                                    .frame(width: 100)
                                
                                Text("\(bestScore.name) (YOU)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color(white: 0.46))
                                
                                Text(bestScore.money)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color(white: 0.46))
                                    .padding(.leading, 9)
                            }
                            .font(.custom("OpenSans-Semibold", size: 25))
                        }
                    } else {
                        BackgroundBox {
                            Text("Empty")
                                .font(.custom("OpenSans-Semibold", size: 25))
                        }
                    }
                }
            }
            .frame(width: 934, height: 600)
            .position(x: 650, y: 475)
        }
    }
}


struct LeaderBoardView_Previews: PreviewProvider {
    
    static var previews: some View {
        LeaderBoardView()
    }
}



// MARK: - Ext: Score: Comparable
extension Score: Comparable {
    public static func < (lhs: Score, rhs: Score) -> Bool {
        lhs.money < rhs.money
    }
}
