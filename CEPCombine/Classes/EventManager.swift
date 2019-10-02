//
//  EventManager.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 12/09/19.
//  Copyright © 2019 Isaac Douglas. All rights reserved.
//

import Foundation
import Combine

public class EventManager {
    
    public static func getEvents<T: Event>(onType type: T.Type) -> EventStream<T> {
        let publisher = NotificationCenter
            .default
            .publisher(for: Notification.Name(type.identifier))
            .map({ $0.object as! T })
        
        return EventStream(publisher)
    }
    
    public static func addEvent<T: Event>(event: T) {
        NotificationCenter
            .default
            .post(name: Notification.Name(T.identifier), object: event)
    }
    
}
