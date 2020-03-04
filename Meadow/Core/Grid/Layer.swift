//
//  Layer.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Foundation

public class Layer: Soilable, Clearable, Encodable, Hideable, Updatable {
    
    public typealias Configurator = ((Layer) -> Void)
    
    private enum CodingKeys: CodingKey {
        
        case name
        case cardinal
    }
    
    internal weak var ancestor: SoilableParent?
    
    internal var isDirty = false
    
    var isHidden: Bool = false
    
    var name: String?
    
    public let cardinal: Cardinal
    
    public var upper: Layer? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var lower: Layer? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    var left = Corner(anchor: .left, elevation: World.Constants.floor + 1)
    var right = Corner(anchor: .right, elevation: World.Constants.floor + 1)
    var center = Corner(anchor: .center, elevation: World.Constants.floor + 1)
    
    required init(ancestor: SoilableParent, cardinal: Cardinal) {
        
        self.ancestor = ancestor
        
        self.cardinal = cardinal
    }
    
    public func encode(to encoder: Encoder) throws {
     
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(cardinal, forKey: .cardinal)
    }
    
    @discardableResult func clean() -> Bool {
        
        guard isDirty else { return false }
        
        isDirty = false
        
        return true
    }
    
    func clear() {}
    
    func update(delta: TimeInterval, time: TimeInterval) {}
}

extension Layer {
    
    enum Adjustment {
        
        case corner
        case edge
        case layer
        case recursive
    }
    
    public var base: Int { return min(left.elevation, right.elevation, center.elevation) }
    public var peak: Int{ return max(left.elevation, right.elevation, center.elevation) }
    public var centerElevation: Int { return center.elevation }
    
    public func set(ordinal: Ordinal, elevation: Int) {
        
        switch ordinal {
            
        case .northEast,
             .southWest:
            
            adjust(corner: Corner(anchor: .left, elevation: elevation))
            
        case .southEast,
             .northWest:
            
            adjust(corner: Corner(anchor: .right, elevation: elevation))
        }
    }
    
    public func set(center elevation: Int) {
        
        adjust(corner: Corner(anchor: .center, elevation: elevation))
    }
    
    public func get(elevation ordinal: Ordinal) -> Int {
        
        switch ordinal {
            
        case .northEast,
             .southWest:
            
            return left.elevation
            
        case .southEast,
             .northWest:
            
            return right.elevation
        }
    }
    
    func adjust(corner: Corner) {
        
        switch corner.anchor {
            
        case .center:
            
            self.center = corner
            
        case .left:
            
            self.left = corner
            
        case .right:
            
            self.right = corner
        }
        
        becomeDirty()
    }
}
