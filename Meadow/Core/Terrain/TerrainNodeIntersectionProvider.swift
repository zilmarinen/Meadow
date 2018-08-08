//
//  TerrainNodeIntersectionProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol TerrainNodeIntersectionProvider {
    
    var intersections: [Polyhedron] { get }
    
    var totalIntersections: Int { get }
    
    func intersection(at index: Int) -> Polyhedron?
    func find(intersection polyhedron: Polyhedron) -> Polyhedron?
    func add(intersection polyhedron: Polyhedron) -> Bool
    func remove(intersection polyhedron: Polyhedron) -> Bool
}

extension TerrainNodeIntersectionProvider {
    
    public var totalIntersections: Int { return intersections.count }
    
    public func intersection(at index: Int) -> Polyhedron? {
        
        return intersections[index]
    }
    
    public func find(intersection polyhedron: Polyhedron) -> Polyhedron? {
        
        return intersections.first { $0 == polyhedron }
    }
}
