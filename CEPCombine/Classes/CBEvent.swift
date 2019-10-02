//
//  CBEvent.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 10/09/19.
//  Copyright © 2019 Isaac Douglas. All rights reserved.
//

import Foundation

public protocol CBEvent {
    var timestamp: Date { get set }
}

extension CBEvent {
    static var identifier: String {
        return String(describing: self)
    }
}
