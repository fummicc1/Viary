//
//  VText.swift
//  
//
//  Created by Fumiya Tanaka on 2023/04/08.
//

import Foundation
import SwiftUI

public func CopyableText(_ text: String) -> some View {
    Text(text).textSelection(.enabled)
}
