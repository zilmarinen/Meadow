//
//  Footpath.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Footpath: Grid<FootpathChunk, FootpathTile> {
    
    override init(ancestor: SoilableParent) {
        
        super.init(ancestor: ancestor)
        
        name = "Footpath"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var category: SceneGraphNodeCategory { return .footpath }
}

extension Footpath: GridDecodable {
    
    typealias JSON = FootpathJSON
    
    func decode(json: FootpathJSON) {
        
        //
    }
}
