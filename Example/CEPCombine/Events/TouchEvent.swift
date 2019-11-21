//
//  TouchEvent.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 29/09/19.
//  Copyright © 2019 Isaac Douglas. All rights reserved.
//

import CEPCombine

class TouchEvent: CBEvent {
    var source: String?
    var timestamp: Date
    var data: TouchType
    
    enum TouchType: String {
        case began, ended
    }
    
    init(data: TouchType, source: String? = nil) {
        self.source = source
        self.timestamp = Date()
        self.data = data
    }
}
