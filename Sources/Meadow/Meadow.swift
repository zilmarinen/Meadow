//
//  Meadow.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class Meadow: SCNNode, Codable, Responder, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case surface
    }
    
    public static var bundle: Bundle { .module }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public let surface: Surface
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        surface = try container.decode(Surface.self, forKey: .surface)
        
        super.init()
        
        addChildNode(surface)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(surface, forKey: .surface)
    }
}

extension Meadow {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        surface.clean()
        
        isDirty = false
        
        return true
    }
}

extension Meadow {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}
