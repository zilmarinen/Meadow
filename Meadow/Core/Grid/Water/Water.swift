//
//  Water.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Water: Grid<WaterChunk, WaterTile<WaterEdge>> {
    
    override init(ancestor: SoilableParent) {
    
    super.init(ancestor: ancestor)
        
        name = "Water"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var category: SceneGraphNodeCategory { return .water }
}

extension Water: GridDecodable {
    
    typealias JSON = WaterJSON
    
    func decode(json: WaterJSON) {
        
        //
    }
}
