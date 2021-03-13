//
//  PriorityQueue.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import CoreGraphics
import Foundation

struct PriorityQueueNode {
    
    let coordinate: Coordinate
    let priority: CGFloat
}

class PriorityQueue {
    
    var queue: [PriorityQueueNode] = []
    
    var isDirty: Bool = false
    
    var isEmpty: Bool { queue.isEmpty }
    
    func enqueue(coordinate: Coordinate, priority: CGFloat) {
        
        queue.append(PriorityQueueNode(coordinate: coordinate, priority: priority))
        
        isDirty = true
    }
    
    func dequeue() -> Coordinate? {
        
        clean()
        
        return queue.removeFirst().coordinate
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
