//
//  LangListSelectionView.swift
//  
//
//  Created by Fumiya Tanaka on 2023/03/02.
//

import Foundation
import Entities
import SharedUI
import SwiftUI

struct LangListSelectionView: View {

    @Binding var selectedLang: Lang

    var body: some View {
        Picker(
            selection: $selectedLang
        ) {
            ForEach(Lang.allCases) { lang in
                SelectableText(lang.displayName)
                    .bold()
                    .tag(lang)
            }
        } label: {
            SelectableText("Language")
        }
        .pickerStyle(.segmented)
    }
}
