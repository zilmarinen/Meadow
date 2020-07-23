//
//  GridResolver.swift
//  Meadow
//
//  Created by Zack Brown on 07/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

protocol GridResolver: class, Updatable {
    
    var identifiers: [Int] { get set }
    
    func enqueue(identifier: Int)
    func resolve(identifier: Int)
}

extension GridResolver {
    
    func enqueue(identifier: Int) {
        
        let other = identifiers.first { $0 == identifier }
        
        guard other == nil else { return }
        
        identifiers.append(identifier)
    }
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        guard let identifier = identifiers.first else { return }
        
        identifiers.removeFirst()
        
        resolve(identifier: identifier)
    }
}
