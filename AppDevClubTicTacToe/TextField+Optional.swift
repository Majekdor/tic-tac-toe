//
//  TextField+Optional.swift
//  AppDevClubTicTacToe
//
//  Created by Kevin Barnes on 9/26/23.
//

import SwiftUI

extension TextField where Label == Text {
    
    /// Custom extension for TextField.
    /// - Parameters:
    ///   - titleKey: <#titleKey description#>
    ///   - optionalText: <#optionalText description#>
    init(_ titleKey: LocalizedStringKey, optionalText: Binding<String?>) {
        self.init(
            titleKey,
            text: Binding(
                get: {
                    optionalText.wrappedValue ?? ""
                },
                set: { newValue in
                    optionalText.wrappedValue = newValue
                }
            )
        )
    }
}
