//
//  Tree.swift
//  Meadow
//
//  Created by Zack Brown on 01/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public class Tree<T: Equatable>: Collection {
    
    var children: [T] = []
    
    public init(_ children: [T] = []) {
        
        self.children = children
    }
    
    public subscript(index: Int) -> T {
        
        precondition((startIndex ..< endIndex).contains(index), "Index out of bounds")
        
        return children[index]
    }
    
    public var startIndex: Int { return 0 }
    
    public var endIndex: Int { return children.count }
    
    public func index(after i: Int) -> Int { return i + 1 }
}

extension Tree: Equatable {
    
    public static func == (lhs: Tree, rhs: Tree) -> Bool {
        
        return lhs.children == rhs.children
    }
}

extension Tree {
    
    public var last: T? { return children.last }
    
    public func index(of child: T) -> Int? { return children.index(of: child) }
    
    @discardableResult public func append(_ child: T) -> Bool {
        
        guard children.index(of: child) == nil else { return false }
        
        children.append(child)
        
        return true
    }
    
    @discardableResult public func remove(_ child: T) -> Bool {
        
        guard let index = index(of: child) else { return false }
        
        children.remove(at: index)
        
        return true
    }
    
    @discardableResult public func remove(at: Int) -> T {
    
        precondition((startIndex ..< endIndex).contains(at), "Index out of bounds")
    
        return children.remove(at: at)
    }
}
