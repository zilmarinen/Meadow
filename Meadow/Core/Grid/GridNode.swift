//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridNode: Soilable {
    
    public var isDirty: Bool = false
    
    let volume: Volume
    
    public required init(volume: Volume) {
        
        self.volume = volume
    }
}

extension GridNode: Hashable {
    
    public static func == (lhs: GridNode, rhs: GridNode) -> Bool {
        
        return lhs.volume == rhs.volume
    }
    
    public var hashValue: Int {
        
        return volume.hashValue
    }
}

extension GridNode {
    
    public func clean() {
        
        if isDirty {
            
            //
        }
    }
}
