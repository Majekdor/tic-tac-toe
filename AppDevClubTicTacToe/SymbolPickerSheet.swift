//
//  SymbolPickerSheet.swift
//  AppDevClubTicTacToe
//
//  Created by Kevin Barnes on 9/26/23.
//

import SwiftUI

struct SymbolPickerSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedSymbol: String
    
    let sfSymbols: [String] = [
        "info.circle",
        "briefcase",
        "square.and.arrow.up",
        "person.3",
        "doc.on.doc",
        "mug",
        "calendar",
        "book",
        "bookmark",
        "mail",
        "graduationcap",
        "backpack",
        "link",
        "dumbbell",
        "trophy",
        "medal",
        "megaphone",
        "magnifyingglass",
        "shield",
        "bell",
        "tag",
        "camera",
        "gear",
        "basket",
        "theatermasks",
        "crown",
        "fork.knife",
        "xmark",
        "circle"
    ]
    
    private let threeColumnGrid = [
        GridItem(.flexible(minimum: 40), spacing: 20),
        GridItem(.flexible(minimum: 40), spacing: 20),
        GridItem(.flexible(minimum: 40), spacing: 20),
        GridItem(.flexible(minimum: 40), spacing: 20),
        GridItem(.flexible(minimum: 40), spacing: 20),
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns: self.threeColumnGrid, spacing: 20) {
                    ForEach(self.sfSymbols, id: \.self) { symbol in
                        ZStack {
                            Circle()
                                .foregroundColor(self.selectedSymbol == symbol ? .cyan : .secondary)
                                .opacity(self.selectedSymbol == symbol ? 0.3 : 0.2)
                                .shadow(radius: 5)
                            
                            Image(systemName: symbol)
                                .font(.system(size: 25))
                        }
                        .onTapGesture {
                            self.selectedSymbol = symbol
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Select Symbol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            self.dismiss()
                        },
                        label: {
                            Text("Done")
                        }
                    )
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct SymbolPickerSheetView_Previews: PreviewProvider {
    
    @State static var showSheet: Bool = true
    
    static var previews: some View {
        Text("Hi")
            .sheet(isPresented: self.$showSheet) {
                SymbolPickerSheet(
                    selectedSymbol: .constant("briefcase")
                )
            }
    }
}
