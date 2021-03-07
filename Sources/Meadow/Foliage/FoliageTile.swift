//
//  FoliageTile.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import Foundation

public class FoliageTile: Tile {
    
    public override var category: Int { SceneGraphCategory.foliageTile.rawValue }
    
    override func invalidate(neighbours: Bool) {
        
        //
        
        super.invalidate(neighbours: neighbours)
    }
    
    public override func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
    
    override func traversable(cardinal: Cardinal) -> Bool { return false }
    
    override func collapse() {
        
        //
    }
    
    override func render(position: Vector) -> [Polygon] {
        
        let tree = Tree(sides: 4, pointy: true)
        
        let transform = Transform(position: position)
        
        return tree.transformed(by: transform).polygons
    }
}
