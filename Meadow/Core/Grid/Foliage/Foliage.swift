//
//  Foliage.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Foliage: Grid<FoliageChunk, FoliageTile> {
    
    override init(graph: Graph, ancestor: SoilableParent) {
    
        super.init(graph: graph, ancestor: ancestor)
        
        name = "Foliage"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var category: SceneGraphNodeCategory { return .foliage }
}

extension Foliage: GridDecodable {
    
    typealias JSON = FoliageJSON
    
    func decode(json: FoliageJSON) {
        
        //
    }
}
