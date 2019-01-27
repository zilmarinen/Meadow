//
//  SceneGraphParent.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol SceneGraphParent: class, TreeParent {
    
    var children: [ChildType] { get }
}

extension SceneGraphParent {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> ChildType? {
        
        guard !children.isEmpty else { return nil }
        
        return children[index]
    }
}
