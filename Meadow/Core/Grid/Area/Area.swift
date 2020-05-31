//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Area: Grid<AreaChunk, AreaTile<AreaEdge>> {
    
    override init(ancestor: SoilableParent) {
    
        super.init(ancestor: ancestor)
        
        name = "Area"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var category: SceneGraphNodeCategory { return .area }
}

extension Area: GridDecodable {
    
    typealias JSON = AreaJSON
    
    func decode(json: AreaJSON) {
        
        //
    }
}
