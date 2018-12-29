//
//  PropNode.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class PropNode: SCNNode, SceneGraphChild {
    
    public let coordinate: Coordinate
    
    public let footprint: Footprint
    
    public let prop: Prop
    
    var isDirty: Bool = false
    
    init(prop: Prop, coordinate: Coordinate) {
        
        self.prop = prop
        
        self.coordinate = coordinate
        
        self.footprint = prop.footprint
        
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension PropNode: SceneGraphSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
        }
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        //
        
        isDirty = false
    }
}

extension PropNode: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
    }
}
