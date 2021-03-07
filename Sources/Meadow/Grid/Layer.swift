//
//  Layer.swift
//
//  Created by Zack Brown on 26/01/2021.
//

import Foundation

public class Layer: NSObject, Codable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
    }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var name: String?
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { fatalError("Layer.category must be overridden") }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            guard oldValue != isHidden else { return }
            
            becomeDirty()
        }
    }
    
    weak var upper: Layer?
    weak var lower: Layer?
    
    let coordinate: Coordinate
    
    required init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
    
    public func update(delta: TimeInterval, time: TimeInterval) { fatalError("Layer.update() must be overridden") }
}
