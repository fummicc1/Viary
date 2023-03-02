//
//  InputTypeSelectionView.swift
//  
//
//  Created by Fumiya Tanaka on 2023/03/02.
//

import Foundation
import SwiftUI

public struct InputTypeSelectionView: View {

    @Binding var selectedInputType: CreateViary.InputType

    public var body: some View {
        Picker("入力方式", selection: $selectedInputType) {
            ForEach(CreateViary.InputType.allCases) { inputType in
                Text(inputType.description)
            }
        }

    }
}
