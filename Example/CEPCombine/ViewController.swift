//
//  ViewController.swift
//  CEPCombine
//
//  Created by IsaacDouglas on 10/01/2019.
//  Copyright (c) 2019 IsaacDouglas. All rights reserved.
//

import UIKit
import CEPCombine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let point = CBEventManager
            .getEvents(onType: PointEvent.self)
            .stream
            .filter({ $0.data.y > 100 })
            .followedBy(predicate: { $0.data.x < $1.data.x })
        
        let touch = CBEventManager
            .getEvents(onType: TouchEvent.self)
            .stream
        
        point
            .merge(with: touch)
            .subscribe(completion: { (p, t) in
                guard abs(t.timestamp.distance(to: p.0.timestamp)) <= 3 else { return }
                print(t.data, p.0.data, p.1.data)
            })
        
        
        CBEventManager
            .getEvents(onType: PointEvent.self)
            .stream
            .collect(10)
            .group(by: { $0 })
            .subscribe(completion: { values in
                print(values)
            })
        
        CBEventManager
            .getEvents(onType: PointEvent.self)
            .stream
            .collect(10)
            .order(by: { $0.data.x < $1.data.x })
            .subscribe(completion: { values in
                print(values.map({ $0.data }))
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let point = t.location(in: self.view)
            CBEventManager.addEvent(event: PointEvent(data: point))
        }
        CBEventManager.addEvent(event: TouchEvent(data: .began))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        CBEventManager.addEvent(event: TouchEvent(data: .ended))
    }
}
