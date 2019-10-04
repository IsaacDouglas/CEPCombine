//
//  Publisher.swift
//  CEPCombine
//
//  Created by Isaac Douglas on 19/09/19.
//  Copyright © 2019 Isaac Douglas. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    
    private func pairwise() -> Publishers.Map<Publishers.Filter<Self>, (Output, Output)> {
        var previous: Output? = nil
        let pair = self
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
        return pair
    }
    
    public func followedBy(predicate: @escaping (Self.Output, Self.Output) -> Bool) -> Publishers.Filter<Publishers.Map<Publishers.Filter<Self>, (Self.Output, Self.Output)>> {
        return pairwise().filter(predicate)
    }
    
    public func subscribe(completion: @escaping ((Self.Output) -> Void)) {
        _ = self
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: completion)
    }
    
    public func merge<T: Publisher>(with stream: T, completion: @escaping ((Self.Output, T.Output) -> Void)) where T.Failure == Self.Failure {
        
        let first = self
            .map({ $0 as Any })
        
        let second = stream
            .map({ $0 as Any })
        
        first
            .merge(with: second)
            .collect(2)
            .subscribe(completion: { values in
                guard
                    let f = values.first(where: { $0 is Self.Output }).map({ $0 as! Self.Output }),
                    let s = values.first(where: { $0 is T.Output }).map({ $0 as! T.Output })
                    else { return }
                completion(f, s)
            })
    }
    
    public func duplicate(_ count: Int = 2) -> [Self] {
        return (0 ..< count)
            .map({ _ in self })
    }

    public func group<T: Sequence, Key: Hashable>(by keyForValue: @escaping ((T.Element) throws -> Key)) -> Publishers.Map<Self, [[T.Element]]> where T == Self.Output {
        return self
            .map({ values -> [[T.Element]] in
                let dictionary = try! Dictionary(grouping: values, by: keyForValue)
                return dictionary.map({ $0.value })
            })
    }
    
    public func order<T: Sequence>(by: @escaping ((T.Element, T.Element) -> Bool)) -> Publishers.Map<Self, [T.Element]> where T == Self.Output {
        return self
            .map({ $0.sorted(by: by) })
    }
}
