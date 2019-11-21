//
//  Extension.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 19/11/19.
//

import Foundation

public extension Array where Element: CBEvent {
    func addEvent(every time: TimeInterval) {
        CBEventManager.addEvent(every: time, with: self)
    }
}
