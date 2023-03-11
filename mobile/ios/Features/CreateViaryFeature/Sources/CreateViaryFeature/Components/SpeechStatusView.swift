//
//  SpeechStatusView.swift
//  
//
//  Created by Fumiya Tanaka on 2023/03/11.
//

import Foundation
import ComposableArchitecture
import SpeechToText
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
            startedView
        case .speeching(let speechToTextModel):
            speechingView(model: speechToTextModel)
        case .stopped(let speechToTextModel):
            stoppedView(model: speechToTextModel)
        }
    }

    var idleView: some View {
        HStack {
            Text("音声で日記を描きましょう")
            Button {
                viewStore.send(.startRecording)
            } label: {
                Text("録音開始")
                Image(systemSymbol: .mic)
            }
        }
    }

    var startedView: some View {
        idleView
            .opacity(opacity)
            .onAppear {
                withAnimation {
                    opacity = abs(1 - opacity)
                }
            }
    }

    func speechingView(model: SpeechToTextModel) -> some View {
        VStack {
            HStack {
                if !model.isFinal {
                    Text("録音中です")
                }
                Button {
                    viewStore.send(.stopRecording)
                } label: {
                    HStack {
                        Text("停止")
                        Image(systemSymbol: .stop)
                    }
                }
            }
            Text(model.text)
        }
    }

    func stoppedView(model: SpeechToTextModel) -> some View {
        VStack { }
    }
}
