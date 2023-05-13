//
//  ContentView.swift
//  Ja2EnServiceSandBox
//
//  Created by Fumiya Tanaka on 2023/05/13.
//

import SwiftUI
import Ja2En

let service = Ja2EnServiceImpl.liveValue

struct ContentView: View {

    @State @MainActor private var inputs: String = "こんにちは!"
    @State @MainActor private var outputs: String?

    var body: some View {
        VStack {
            TextField("日本語を入力して下さい", text: $inputs)
            if let outputs {
                Text("翻訳結果: \(outputs)")
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }
            }
            Spacer()
            Button("翻訳") {
                Task {
                    do {
                        outputs = nil
                        let inputs = self.inputs
                        let out = try await service.translate(message: inputs)
                        await MainActor.run {
                            outputs = out
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            Spacer().frame(height: 48)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
