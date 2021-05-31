//
//  PriorityQueue.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import CoreGraphics
import Foundation

class PriorityQueueNode<V> {
    
    let priority: Double
    let value: V
    
    required init(value: V, priority: Double) {
        
        self.value = value
        self.priority = priority
    }
}

class PriorityQueue<V> {
    
    var queue: [PriorityQueueNode<V>] = []
    
    var isDirty: Bool = false
    
    var isEmpty: Bool { queue.isEmpty }
    
    func enqueue(value: V, priority: Double) {
        
        queue.append(PriorityQueueNode<V>(value: value, priority: priority))
        
        isDirty = true
    }
    
    func dequeue() -> PriorityQueueNode<V>? {
        
        clean()
        
        return queue.removeFirst()
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
