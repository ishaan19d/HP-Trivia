//
//  Constants.swift
//  HP Trivia
//
//  Created by Ishaan Das on 21/06/24.
//

import Foundation
import SwiftUI

enum Constants {
    static let hpFont = "PartyLetPlain"
}

struct ParchmentBackground: View {
    var body: some View{
        Image(.parchment)
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

extension Button {
    func doneButton() -> some View {
        self
        .font(.largeTitle)
        .padding()
        .buttonStyle(.borderedProminent)
        .tint(.brown)
        .foregroundStyle(.white)
    }
}
