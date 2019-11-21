//
//  Publisher.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 19/09/19.
//  Copyright © 2019 Isaac Douglas. All rights reserved.
//

import Foundation
import Combine

public typealias Map = Publishers.Map
public typealias Filter = Publishers.Filter
public typealias CollectByCount = Publishers.CollectByCount
public typealias Merge = Publishers.Merge

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    
    private func pairwise() -> Map<Filter<Self>, (Output, Output)> {
        var previous: Output? = nil
        return self
            .filter({ element in
                if previous == nil {
                    previous = element
                    return false
                } else {
                    return true
                }
            })
            .map({ element -> (Output, Output) in
                defer { previous = element }
                return (previous!, element)
            })
    }
    
    public func followed(by predicate: @escaping (Self.Output, Self.Output) -> Bool) -> Filter<Map<Filter<Self>, (Self.Output, Self.Output)>> {
        return pairwise().filter(predicate)
    }
    
    public func subscribe(completion: @escaping ((Self.Output) -> Void)) {
        _ = self
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: completion)
    }
    
    public func merge<T: Publisher>(with stream: T) -> Map<Filter<Map<CollectByCount<Merge<Map<Self, Any>, Map<T, Any>>>, (Self.Output?, T.Output?)>>, (Self.Output, T.Output)> {
        
        let first = self
            .map({ $0 as Any })
        
        let second = stream
            .map({ $0 as Any })
        
        return first
            .merge(with: second)
            .collect(2)
            .map({ values -> (Self.Output?, T.Output?) in
                guard
                    let f = values.first(where: { $0 is Self.Output }).map({ $0 as! Self.Output }),
                    let s = values.first(where: { $0 is T.Output }).map({ $0 as! T.Output })
                    else { return (nil, nil) }
                return (f, s)
            })
            .filter({ $0.0 != nil && $0.1 != nil })
            .map({ ($0.0!, $0.1!) })
    }
    
    public func duplicate(_ count: Int = 2) -> [Self] {
        return (0 ..< count)
            .map({ _ in self })
    }

    public func group<T: Sequence, Key: Hashable>(by keyForValue: @escaping ((T.Element) throws -> Key)) -> Map<Self, [[T.Element]]> where T == Self.Output {
        return self
            .map({ values -> [[T.Element]] in
                let dictionary = try! Dictionary(grouping: values, by: keyForValue)
                return dictionary.map({ $0.value })
            })
    }
    
    public func order<T: Sequence>(by: @escaping ((T.Element, T.Element) -> Bool)) -> Map<Self, [T.Element]> where T == Self.Output {
        return self
            .map({ $0.sorted(by: by) })
    }
}
