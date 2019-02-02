//
//  Floor.swift
//  Meadow
//
//  Created by Zack Brown on 13/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Floor: SCNNode, SceneGraphChild {
    
    public var observer: SceneGraphObserver?
    
    public var volume: Volume {
        
        return Volume(coordinate: Coordinate.zero, size: Size.one)
    }
    
    public var color: Color? {
        
        didSet {
            
            guard let color = color else { return }
            
            let material = (geometry?.firstMaterial ?? SCNMaterial())
            
            material.diffuse.contents = color.color
        }
    }
    
    public override init() {
        
        super.init()
        
        self.name = "Floor"
        self.categoryBitMask = SceneGraphNodeType.floor.rawValue
        
        let floor = SCNFloor()
        
        floor.reflectivity = 0.0
        
        self.geometry = floor
        
        self.position = SCNVector3(x: 0.0, y: Axis.Y(y: World.floor), z: 0.0)
        
        self.color = ArtDirector.shared?.color(named: "white")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
