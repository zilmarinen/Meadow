//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol GridNodeDelegate {
    
    func didBecomeDirty(node: GridNode)
}

public class GridNode {
    
    public struct GridNodeNeighbour: Hashable {
        
        let edge: GridEdge
        let node: GridNode
    }
    
    private let delegate: GridNodeDelegate
    
    private var isDirty: Bool = false
    
    let volume: Volume
    
    public required init(delegate: GridNodeDelegate, volume: Volume) {
        
        self.delegate = delegate
        
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
    
    func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
        
        delegate.didBecomeDirty(node: self)
    }
}
