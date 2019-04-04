//
//  AreaChunk.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class AreaChunk: GridChunk<AreaTile, AreaNode<AreaNodeEdge>> {
    
}

extension AreaChunk {
    
    public var renderState: AreaNodeEdge.RenderState {
        
        get {
            
            let cutaway = children.filter { $0.renderState == .cutaway }
            
            return (cutaway.count == totalChildren ? .cutaway : .raised)
        }
        
        set {
            
            children.forEach { $0.renderState = newValue }
        }
    }
}
