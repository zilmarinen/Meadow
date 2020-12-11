//
//  PriorityQueue.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import CoreGraphics
import Foundation

struct PriorityQueueNode {
    
    let gridNode: GridNode
    let priority: CGFloat
}

class PriorityQueue {
    
    var queue: [PriorityQueueNode] = []
    
    var isDirty: Bool = false
    
    var isEmpty: Bool { queue.isEmpty }
    
    func enqueue(gridNode: GridNode, priority: CGFloat) {
        
        queue.append(PriorityQueueNode(gridNode: gridNode, priority: priority))
        
        isDirty = true
    }
    
    func dequeue() -> GridNode? {
        
        clean()
        
        return queue.removeFirst().gridNode
    }
    
    @discardableResult func clean() -> Bool {
        
        guard isDirty else { return false }
        
        queue.sort { (lhs, rhs) -> Bool in
        
            return lhs.priority < rhs.priority
        }
        
        isDirty = false
        
        return true
    }
}
