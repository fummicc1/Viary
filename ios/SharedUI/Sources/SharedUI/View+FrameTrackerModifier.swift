// Based on: https://github.com/AndreaMiotto/PartialSheet/blob/master/Sources/PartialSheet/Extensions/View%2BFrameTrackerModifier.swift
//
//  FrameTracker.swift
//
//
//  Created by Andrea Miotto on 28/02/22.
//

import SwiftUI

/**
 Add a Tracker on the frame of the current View.
 On every cnages the *onChange* callback will be triggered.
 */
public struct AddFrameTracker: ViewModifier {
    /// Preference Key for the Sheet Presener
    public struct PresenterPreferenceKey: PreferenceKey {
        public static func reduce(value: inout [PreferenceData], nextValue: () -> [PreferenceData]) {
            value.append(contentsOf: nextValue())
        }
        public static var defaultValue: [PreferenceData] = []
    }

    /// Preference Key for the Sheet Content
    public struct SheetPreferenceKey: PreferenceKey {
        public static func reduce(value: inout [PreferenceData], nextValue: () -> [PreferenceData]) {
            value.append(contentsOf: nextValue())
        }
        public static var defaultValue: [PreferenceData] = []
    }

    /// Data Stored in the Preferences
    public struct PreferenceData: Equatable {
        let bounds: CGRect
    }

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    // Add a tracking on the presenter frame
                    Color.clear.preference(
                        key: PresenterPreferenceKey.self,
                        value: [PreferenceData(bounds: proxy.frame(in: .global))]
                    )
                }
            )
    }
}

struct OnFrameDidChange: ViewModifier {
    var onChange: ([AddFrameTracker.PreferenceData]) -> Void

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(AddFrameTracker.PresenterPreferenceKey.self, perform: { (prefData) in
                DispatchQueue.main.async {
                    onChange(prefData)
                }
            })
    }
}

extension View {
    /**
     Add a Tracker on the frame of the current View.
     */
    func trackFrame() -> some View {
        self.modifier(AddFrameTracker())
    }

    /**
     On every frame change the *onChange* callback will be triggered.
     Remeber to call the **trackFrame func** on the same view first.
     */
    public func onFrameDidChange(_ onChange: @escaping ([AddFrameTracker.PreferenceData]) -> Void) -> some View {
        self.modifier(OnFrameDidChange(onChange: onChange))
    }
}
