//
//  Layer.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Foundation

class Layer: Soilable, Clearable, Encodable, Renderable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case cardinal
    }
    
    internal weak var ancestor: SoilableParent?
    
    internal var isDirty = false
    
    var isHidden: Bool = false
    
    var name: String?
    
    let cardinal: Cardinal
    
    var upper: Layer? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    var lower: Layer? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    var left = Corner(anchor: .left, elevation: World.Constants.floor)
    var right = Corner(anchor: .right, elevation: World.Constants.floor)
    var center = Corner(anchor: .center, elevation: World.Constants.floor)
    
    required init(ancestor: SoilableParent, cardinal: Cardinal) {
        
        self.ancestor = ancestor
        
        self.cardinal = cardinal
    }
    
    func encode(to encoder: Encoder) throws {
     
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
    
    var base: Int { return min(left.elevation, right.elevation, center.elevation) }
    var peak: Int{ return max(left.elevation, right.elevation, center.elevation) }
    var centerElevation: Int { return center.elevation }
    
    func set(ordinal: Ordinal, elevation: Int) {
        
        switch ordinal {
            
        case .northEast,
             .southWest:
            
            adjust(corner: Corner(anchor: .left, elevation: elevation))
            
        case .southEast,
             .northWest:
            
            adjust(corner: Corner(anchor: .right, elevation: elevation))
        }
    }
    
    func set(center elevation: Int) {
        
        adjust(corner: Corner(anchor: .center, elevation: elevation))
    }
    
    func get(elevation ordinal: Ordinal) -> Int {
        
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
        
        //TODO
    }
}
