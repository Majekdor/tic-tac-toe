//
//  ContentView.swift
//  AppDevClubTicTacToe
//
//  Created by Kevin Barnes on 11/3/22.
//

import SwiftUI

struct ContentView: View {
    
    // These state variables store markers (X or O) for each box.
    @State private var topLeft: String = ""
    @State private var topCenter: String = ""
    @State private var topRight: String = ""
    @State private var middleLeft: String = ""
    @State private var middleCenter: String = ""
    @State private var middleRight: String = ""
    @State private var bottomLeft: String = ""
    @State private var bottomCenter: String = ""
    @State private var bottomRight: String = ""
    
    // Who's turn it is (X or O).
    @State private var gameTurn: GameTurn = .X
    
    // The winner of the game (if there is one).
    @State private var winner: String? = nil
    
    var body: some View {
        VStack(spacing: 60) {
            // Who's turn it is
            Text("\(gameTurn == .X ? "X" : "O")'s Turn")
                .font(.title) // Bigger font
                .fontWeight(.heavy)
                .underline(color: .accentColor) // Underline in our accent color
                .padding(.top, 30) // Add padding (space) at the top
            
            // Top row
            HStack(spacing: 60) {
                GameBoxView(systemName: $topLeft, gameTurn: $gameTurn)
                
                GameBoxView(systemName: $topCenter, gameTurn: $gameTurn)
                
                GameBoxView(systemName: $topRight, gameTurn: $gameTurn)
            }
            
            // Middle row
            HStack(spacing: 60) {
                GameBoxView(systemName: $middleLeft, gameTurn: $gameTurn)
                
                GameBoxView(systemName: $middleCenter, gameTurn: $gameTurn)
                
                GameBoxView(systemName: $middleRight, gameTurn: $gameTurn)
            }
            
            // Bottom row
            HStack(spacing: 60) {
                GameBoxView(systemName: $bottomLeft, gameTurn: $gameTurn)
                
                GameBoxView(systemName: $bottomCenter, gameTurn: $gameTurn)
                
                GameBoxView(systemName: $bottomRight, gameTurn: $gameTurn)
            }
            
            // Winner text (if there is one)
            if winner != nil {
                HStack {
                    Text("Winner: ")
                    
                    Image(systemName: winner!)
                }
            }
            
            // Spacer pushes everything up
            Spacer()
        }
        // Every time the game turn changes, check if someone has won.
        .onChange(of: gameTurn, perform: { _ in // This could give you the new value of game turn, which we don't care about since it just alternates
            winner = nil // Assume no winner every time game turn changes
            if allMatch(topLeft, topCenter, topRight) {
                winner = topLeft
            } else if allMatch(middleLeft, middleCenter, middleRight) {
                winner = middleLeft
            } else if allMatch(bottomLeft, bottomCenter, bottomRight) {
                winner = bottomLeft
            } else if allMatch(topLeft, middleLeft, bottomLeft) {
                winner = topLeft
            } else if allMatch(topCenter, middleCenter, bottomCenter) {
                winner = topCenter
            } else if allMatch(topRight, middleRight, bottomRight) {
                winner = topRight
            } else if allMatch(topLeft, middleCenter, bottomRight) {
                winner = topLeft
            } else if allMatch(topRight, middleCenter, bottomLeft) {
                winner = topRight
            }
        })
    }
    
    // Check if all three strings match and aren't empty
    func allMatch(_ first: String, _ second: String, _ third: String) -> Bool {
        print("\(first) \(second) \(third)")
        return first != "" && first == second && first == third
    }
}

struct GameBoxView: View {
    
    // These bound variables come from the parent view. Since they're bound, updating them in this view updates the variables in the parent view as well.
    @Binding var systemName: String
    @Binding var gameTurn: GameTurn
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: 40, height: 40) // Make the image bigger
            .overlay(
                Rectangle() // Overlay a rectangle
                    .stroke(Color.accentColor)
                    .frame(width: 100, height: 100)
                    // The frame is 100 because our spacing in the HStack and VStack we defined to be 60. A spacing of 60 really means each object in the stack is padded by 30 on each side. So if our images is 40x40, and has 30 on each side, 30 + 30 + 40 = 100 to create the grid correctly.
            )
            // Code executes when the box is "tapped" or clicked
            .onTapGesture {
                // TODO: Don't allow playing on a taken box.
                switch gameTurn {
                case .X:
                    systemName = "xmark"
                    break
                case .O:
                    systemName = "circle"
                    break
                }
                // Alternate game turn
                gameTurn = gameTurn == .X ? .O : .X
            }
    }
}

enum GameTurn {
    case X
    case O
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
