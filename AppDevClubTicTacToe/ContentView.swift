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
    
    @State private var showNameChangeSheet: Bool = false
    @State private var xPlayer: String = "X"
    @State private var xSymbol: String = "xmark"
    @State private var oPlayer: String = "O"
    @State private var oSymbol: String = "circle"
    
    @AppStorage("xWins") private var xWins: Int = 0
    @AppStorage("oWins") private var oWins: Int = 0
    
    var body: some View {
        VStack(spacing: 60) {
            // Who's turn it is
            Text("\(gameTurn == .X ? xPlayer : oPlayer)'s Turn")
                .font(.title) // Bigger font
                .fontWeight(.heavy)
                .underline(color: .accentColor) // Underline in our accent color
                .padding(.top, 30) // Add padding (space) at the top
            
            // Top row
            HStack(spacing: 60) {
                GameBoxView(systemName: $topLeft, gameTurn: $gameTurn, xSymbol: $xSymbol, oSymbol: $oSymbol)
                
                GameBoxView(systemName: $topCenter, gameTurn: $gameTurn, xSymbol: $xSymbol, oSymbol: $oSymbol)
                
                GameBoxView(systemName: $topRight, gameTurn: $gameTurn, xSymbol: $xSymbol, oSymbol: $oSymbol)
            }
            
            // Middle row
            HStack(spacing: 60) {
                GameBoxView(systemName: $middleLeft, gameTurn: $gameTurn, xSymbol: $xSymbol, oSymbol: $oSymbol)
                
                GameBoxView(systemName: $middleCenter, gameTurn: $gameTurn, xSymbol: $xSymbol, oSymbol: $oSymbol)
                
                GameBoxView(systemName: $middleRight, gameTurn: $gameTurn, xSymbol: $xSymbol, oSymbol: $oSymbol)
            }
            
            // Bottom row
            HStack(spacing: 60) {
                GameBoxView(systemName: $bottomLeft, gameTurn: $gameTurn, xSymbol: $xSymbol, oSymbol: $oSymbol)
                
                GameBoxView(systemName: $bottomCenter, gameTurn: $gameTurn, xSymbol: $xSymbol, oSymbol: $oSymbol)
                
                GameBoxView(systemName: $bottomRight, gameTurn: $gameTurn, xSymbol: $xSymbol, oSymbol: $oSymbol)
            }
            
            VStack(spacing: 15) {
                // Winner text (if there is one)
                if winner != nil {
                    HStack {
                        Text("Winner: ")
                        
                        Text(winner!)
                    }
                    
                    Button(
                        action: {
                            topLeft = ""
                            topCenter = ""
                            topRight = ""
                            middleLeft = ""
                            middleCenter = ""
                            middleRight = ""
                            bottomLeft = ""
                            bottomCenter = ""
                            bottomRight = ""
                            gameTurn = .X
                            winner = nil
                        },
                        label: {
                            Text("New Game")
                        }
                    )
                    .buttonStyle(.borderedProminent)
                }
                
                Button(
                    action: {
                        showNameChangeSheet = true
                    },
                    label: {
                        Text("Change Names")
                    }
                )
                .buttonStyle(.bordered)
                
                HStack(spacing: 30) {
                    VStack {
                        Text("\(xPlayer) wins")
                        
                        Text("\(xWins)")
                            .font(.title)
                            .foregroundStyle(.green)
                    }
                    
                    VStack {
                        Text("\(oPlayer) wins")
                        
                        Text("\(oWins)")
                            .font(.title)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            // Spacer pushes everything up
            Spacer()
        }
        .sheet(isPresented: $showNameChangeSheet) {
            CustomizePlayerSheet(
                xPlayer: $xPlayer,
                xSymbol: $xSymbol,
                oPlayer: $oPlayer,
                oSymbol: $oSymbol
            )
        }
        // Every time the game turn changes, check if someone has won.
        .onChange(of: gameTurn, perform: { _ in // This could give you the new value of game turn, which we don't care about since it just alternates
            winner = nil // Assume no winner every time game turn changes
            if allMatch(topLeft, topCenter, topRight) {
                winner = topLeft == xSymbol ? xPlayer : oPlayer
            } else if allMatch(middleLeft, middleCenter, middleRight) {
                winner = middleLeft == xSymbol ? xPlayer : oPlayer
            } else if allMatch(bottomLeft, bottomCenter, bottomRight) {
                winner = bottomLeft == xSymbol ? xPlayer : oPlayer
            } else if allMatch(topLeft, middleLeft, bottomLeft) {
                winner = topLeft == xSymbol ? xPlayer : oPlayer
            } else if allMatch(topCenter, middleCenter, bottomCenter) {
                winner = topCenter == xSymbol ? xPlayer : oPlayer
            } else if allMatch(topRight, middleRight, bottomRight) {
                winner = topRight == xSymbol ? xPlayer : oPlayer
            } else if allMatch(topLeft, middleCenter, bottomRight) {
                winner = topLeft == xSymbol ? xPlayer : oPlayer
            } else if allMatch(topRight, middleCenter, bottomLeft) {
                winner = topRight == xSymbol ? xPlayer : oPlayer
            }
        })
        .onChange(of: winner) { _ in
            if let winner, winner == xPlayer {
                xWins += 1
            } else if let winner, winner == oPlayer {
                oWins += 1
            }
        }
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
    @Binding var xSymbol: String
    @Binding var oSymbol: String
    
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
                // Don't allow playing on a taken box
                if !systemName.isEmpty {
                    return
                }
                switch gameTurn {
                case .X:
                    systemName = xSymbol
                    break
                case .O:
                    systemName = oSymbol
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

struct CustomizePlayerSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var xPlayer: String
    @Binding var xSymbol: String
    @Binding var oPlayer: String
    @Binding var oSymbol: String
    
    @State private var showXSymbolSheet: Bool = false
    @State private var showOSymbolSheet: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(
                    action: {
                        dismiss()
                    },
                    label: {
                        Text("Done")
                    }
                )
            }
            
            HStack {
                Text("X Player Name:")
                
                TextField("X Player", text: $xPlayer)
            }
            
            HStack {
                Text("X Player Symbol: ")
                
                Image(systemName: xSymbol)
                
                Button(
                    action: {
                        showXSymbolSheet = true
                    },
                    label: {
                        Text("Change")
                            .frame(maxWidth: .infinity)
                    }
                )
                .buttonStyle(.bordered)
            }
            
            HStack {
                Text("O Player Name:")
                
                TextField("O Player", text: $oPlayer)
            }
            
            HStack {
                Text("O Player Symbol: ")
                
                Image(systemName: oSymbol)
                
                Button(
                    action: {
                        showOSymbolSheet = true
                    },
                    label: {
                        Text("Change")
                            .frame(maxWidth: .infinity)
                    }
                )
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .sheet(isPresented: $showXSymbolSheet, content: {
            SymbolPickerSheet(selectedSymbol: $xSymbol)
        })
        .sheet(isPresented: $showOSymbolSheet, content: {
            SymbolPickerSheet(selectedSymbol: $oSymbol)
        })
    }
}
