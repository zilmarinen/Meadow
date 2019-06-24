//
//  PriorityQueue.swift
//  Meadow
//
//  Created by Zack Brown on 21/06/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

class PriorityQueue<T: PriorityQueueNode> {
    
    var nodes: [T] = []
}

extension PriorityQueue {
    
    public var isEmpty: Bool { return nodes.isEmpty }
    
    public func push(node: T) {
        
        if !nodes.contains(node) {
            
            nodes.append(node)
            
            nodes.sort { (lhs, rhs) -> Bool in return lhs.priority < rhs.priority }
        }
    }
    
    public func pop() -> T {
        
        return nodes.removeFirst()
    }
}
