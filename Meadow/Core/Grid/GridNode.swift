//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol GridNodeDelegate: Soilable {
    
    func didBecomeDirty(node: GridNode)
}

public class GridNode: Soilable {
    
    public var isDirty: Bool {
        
        get {
            
            return dirty
        }
    }
    
    private var dirty: Bool = false
    
    private let delegate: GridNodeDelegate
    
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
    
    public func becomeDirty() {
        
        if isDirty { return }
        
        dirty = true
        
        delegate.didBecomeDirty(node: self)
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        //
        
        dirty = false
    }
}
