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
    
    public static func getEvents(onType type: T.Type, source: String? = nil) -> CBEventStream<T> {
        let publisher = NotificationCenter
            .default
            .publisher(for: Notification.Name(type.identifier))
            .map({ $0.object as! T })
            .filter({ event in
                return (source == nil) ? true : (event.source == source)
            })
        
        return CBEventStream(publisher)
    }
    
    public static func addEvent(event: T) {
        NotificationCenter
            .default
            .post(name: Notification.Name(T.identifier), object: event)
    }
    
    public static func addEvent(every time: TimeInterval, with events: [T]) {
        guard !events.isEmpty else { return }
        
        var items = events
        var anyCancellable: AnyCancellable?
        
        anyCancellable = Timer
            .publish(every: time, on: .main, in: .default)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
                if items.isEmpty {
                    anyCancellable?.cancel()
                }else{
                    self.addEvent(event: items.first!)
                    items.remove(at: 0)
                }
            })
    }
}
