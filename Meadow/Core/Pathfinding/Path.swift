//
//  Path.swift
//  Meadow
//
//  Created by Zack Brown on 19/06/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

public struct Path {
    
    let nodes = Tree<PathNode>()
    
    init(nodes: [PathNode]) {
        
        nodes.forEach{ node in
            
            self.nodes.append(node)
        }
    }
}

extension Path {
    
    public var totalChildren: Int { return nodes.children.count }
    
    public var first: PathNode? { return nodes.children.first }
    public var last: PathNode? { return nodes.children.last }
    
    public func child(at index: Int) -> PathNode? {
        
        guard (0 ..< totalChildren).contains(index) else { return nil }
        
        return nodes.children[index]
    }
    
    public func index(of child: PathNode) -> Int? {
        
        return nodes.index(of: child)
    }
    
    public func next(child: PathNode) -> PathNode? {
        
        guard let index = index(of: child) else { return nil }
        
        return self.child(at: index + 1)
    }
}
