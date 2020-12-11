//
//  Traversable.swift
//
//  Created by Zack Brown on 18/11/2020.
//

protocol Traversable {
    
    var movementCost: Int { get }
    var walkable: Bool { get }
    
    func find(neighbour cardinal: Cardinal) -> Self?
    func find(neighbour ordinal: Ordinal) -> Self?
    
    func traversable(cardinal: Cardinal) -> Bool
}
