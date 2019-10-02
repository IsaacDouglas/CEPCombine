//
//  CBEventManager.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 12/09/19.
//  Copyright © 2019 Isaac Douglas. All rights reserved.
//

import Foundation
import Combine

public class CBEventManager<T: CBEvent> {
    
    public static func getEvents(onType type: T.Type) -> CBEventStream<T> {
        let publisher = NotificationCenter
            .default
            .publisher(for: Notification.Name(type.identifier))
            .map({ $0.object as! T })
        
        return CBEventStream(publisher)
    }
    
    public static func addEvent(event: T) {
        NotificationCenter
            .default
            .post(name: Notification.Name(T.identifier), object: event)
    }
    
}
