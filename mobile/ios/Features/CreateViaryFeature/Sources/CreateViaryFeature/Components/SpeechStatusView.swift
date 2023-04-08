//
//  SpeechStatusView.swift
//  
//
//  Created by Fumiya Tanaka on 2023/03/11.
//

import Foundation
import ComposableArchitecture
import SpeechToText
import SharedUI
import SwiftUI

public struct SpeechStatusView: View {

    let status: SpeechStatus
    let viewStore: ViewStoreOf<CreateViary>

    @State private var opacity: Double = 0

    public var body: some View {
        switch status {
        case .idle:
            idleView
        case .started:
            speechingView(model: SpeechToTextModel(text: "", isFinal: false))
        case .speeching(let speechToTextModel):
            speechingView(model: speechToTextModel)
        case .stopped(let speechToTextModel):
            stoppedView(model: speechToTextModel)
        }
    }

    var idleView: some View {
        VStack(alignment: .leading) {
            CopyableText("Note with voice!")
            Button {
                viewStore.send(.startRecording)
            } label: {
                CopyableText("Start noting")
                Image(systemSymbol: .mic)
            }
            .bold()
        }
    }

    func speechingView(model: SpeechToTextModel) -> some View {
        VStack(alignment: .leading) {
            HStack {
                if !model.isFinal {
                    CopyableText("Noting...")
                }
                Button {
                    viewStore.send(.stopRecording)
                } label: {
                    HStack {
                        Text("Stop")
                        Image(systemSymbol: .stop)
                    }
                }
            }
            CopyableText(model.text).padding()
        }
    }

    func stoppedView(model: SpeechToTextModel) -> some View {
        VStack { }
    }
}
