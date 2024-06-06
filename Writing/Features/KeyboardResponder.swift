//
//  KeyboardResponder.swift
//  Writing
//
//  Created by Ben Dreyer on 6/2/24.
//

import Foundation
import UIKit
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    var keyboardWillShowNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    var keyboardWillHideNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

    init() {
        keyboardWillShowNotification.map { notification in
            CGFloat((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0)
        }
//        .assign(to: &$currentHeight)
        .assign(to: \.currentHeight, on: self)
        .store(in: &cancellableSet)

        keyboardWillHideNotification.map { _ in
            CGFloat(0)
        }
//        .assign(to: &$currentHeight)
        .assign(to: \.currentHeight, on: self)
        .store(in: &cancellableSet)
    }

    private var cancellableSet: Set<AnyCancellable> = []
}
