//
//  GridResolver.swift
//  Meadow
//
//  Created by Zack Brown on 14/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol GridResolver: class {
    
    var volumes: Set<Volume> { get set }

    func enqueue(volume: Volume)

    func resolve()
    
    func clean(volume: Volume)
}

extension GridResolver {
    
    public func enqueue(volume: Volume) {
        
        let existingVolume = volumes.first { $0.coordinate.adjacency(to: volume.coordinate) == .equal }
        
        if existingVolume == nil {
            
            volumes.insert(volume)
        }
    }
    
    public func resolve() {
        
        while volumes.count > 0 {
            
            let volume = volumes.removeFirst()
            
            clean(volume: volume)
        }
    }
}
