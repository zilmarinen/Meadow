//
//  TerrainCutaway.swift
//  Meadow
//
//  Created by Zack Brown on 30/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public typealias TerrainCutaway = Polyhedron

protocol TerrainCutawayProvider {
    
    var cutaways: [TerrainCutaway] { get }
    
    var totalCutaways: Int { get }
    
    func cutaway(at index: Int) -> TerrainCutaway?
    func index(of cutaway: TerrainCutaway) -> Int?
    @discardableResult func add(cutaway: TerrainCutaway) -> Bool
    @discardableResult func remove(cutaway: TerrainCutaway) -> Bool
    func stencils(edge: GridEdge) -> [Polyhedron]
}

extension TerrainCutawayProvider {
    
    public var totalCutaways: Int { return cutaways.count }
    
    public func cutaway(at index: Int) -> TerrainCutaway? {
        
        guard !cutaways.isEmpty else { return nil }
        
        return cutaways[index]
    }
    
    public func index(of cutaway: TerrainCutaway) -> Int? {
        
        return cutaways.firstIndex(of: cutaway)
    }
}
