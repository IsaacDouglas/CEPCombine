//
//  CBEventStream.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 12/09/19.
//  Copyright © 2019 Isaac Douglas. All rights reserved.
//

import Foundation
import Combine

public class CBEventStream<T> {
    
    fileprivate let publisher: Filter<Map<NotificationCenter.Publisher, T>>
    
    public init(_ publisher: Filter<Map<NotificationCenter.Publisher, T>>) {
        self.publisher = publisher
    }
    
    public var stream: Filter<Map<NotificationCenter.Publisher, T>> {
        return publisher
    }
}
