//
//  Buildings.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class Buildings: FootprintGrid<BuildingChunk> {
    
    public override var category: SceneGraphCategory { .buildings }
    
    public lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .building, library: library)
    }()
    
    func find(building coordinate: Coordinate) -> BuildingChunk? {
        
        //TODO: implement search
        return nil
    }
}
