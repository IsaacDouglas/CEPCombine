//
//  EventStream.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 12/09/19.
//  Copyright © 2019 Isaac Douglas. All rights reserved.
//

import Foundation
import Combine

public class EventStream<T> {
    
    fileprivate let publisher: Publishers.Map<NotificationCenter.Publisher, T>
    
    public init(_ publisher: Publishers.Map<NotificationCenter.Publisher, T>) {
        self.publisher = publisher
    }
    
    public var stream: Publishers.Map<NotificationCenter.Publisher, T> {
        return publisher
    }
}
