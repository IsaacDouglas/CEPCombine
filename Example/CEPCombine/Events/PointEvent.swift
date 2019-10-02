//
//  PointEvent.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 12/09/19.
//  Copyright © 2019 Isaac Douglas. All rights reserved.
//

import CEPCombine
import UIKit

class PointEvent: CBEvent {
    var timestamp: Date
    var data: CGPoint

    init(data: CGPoint) {
        self.timestamp = Date()
        self.data = data
    }
}

extension PointEvent: Hashable {
    static func == (lhs: PointEvent, rhs: PointEvent) -> Bool {
        return lhs.data == rhs.data
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(self.data))")
    }
}
