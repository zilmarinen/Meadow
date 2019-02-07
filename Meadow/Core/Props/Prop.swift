//
//  Prop.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Prop: SCNNode, SceneGraphChild {
    
    public var observer: SceneGraphObserver?
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
    
    public let footprint: Footprint
    
    public let prototype: PropPrototype
    
    var isDirty: Bool = false
    
    var colorPalette: ColorPalette? {
        
        didSet {
            
            if colorPalette != oldValue {
            
                becomeDirty()
            }
        }
    }
    
    init(observer: SceneGraphObserver, prototype: PropPrototype, footprint: Footprint) {
        
        self.observer = observer
        
        self.prototype = prototype
        
        self.footprint = footprint
        
        super.init()
        
        self.name = prototype.name
        
        self.position = SCNVector3(x: MDWFloat(footprint.coordinate.x), y: Axis.Y(y: footprint.coordinate.y), z: MDWFloat(footprint.coordinate.z))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Prop: SceneGraphSoilable {
    
    @discardableResult public func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
        }
        
        return isDirty
    }
    
    @discardableResult public func clean() -> Bool {
        
        if !isDirty { return false }
        
        guard let model = Model(named: prototype.name), let colorPalette = colorPalette else { return false }
        
        let mesh = model.mesh(colorPalette: colorPalette)
        
        self.geometry = SCNGeometry(mesh: mesh)
        
        isDirty = false
        
        return true
    }
}

extension Prop: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case coordinate
        case rotation
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.footprint.coordinate, forKey: .coordinate)
        try container.encode(self.footprint.rotation, forKey: .rotation)
    }
}
