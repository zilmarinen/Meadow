//
//  GridResolver.swift
//  Meadow
//
//  Created by Zack Brown on 07/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

protocol GridResolver: class, Updatable {
    
    var coordinates: [Coordinate] { get set }
    
    func enqueue(coordinate: Coordinate)
    func resolve(coordinate: Coordinate)
}

extension GridResolver {
    
    func enqueue(coordinate: Coordinate) {
        
        let other = coordinates.first { other -> Bool in
            
            return coordinate.x == other.x && coordinate.z == other.z
        }
        
        guard other == nil else { return }
        
        coordinates.append(coordinate)
    }
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        guard let coordinate = coordinates.first else { return }
        
        coordinates.removeFirst()
        
        resolve(coordinate: coordinate)
    }
}
