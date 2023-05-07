//
//  DateSelectionView.swift
//  
//
//  Created by Fumiya Tanaka on 2023/03/02.
//

import Foundation
import SwiftUI

struct DateSelectionView: View {

    @Binding var selectedDate: Date

    var body: some View {
        DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
    }
}
