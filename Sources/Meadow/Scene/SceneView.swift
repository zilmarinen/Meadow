//
//  SceneView.swift
//
//  Created by Zack Brown on 08/01/2021.
//

import SceneKit

open class SceneView: SCNView {
    
    public var library: MTLLibrary?
    
    public override var scene: SCNScene? {
        
        willSet {
            
            guard let value = newValue as? Scene else { return }
            
            value.library = library
        }
    }
}

extension SceneView {
    
    public func hitTest(point: CGPoint) -> Coordinate {
        
        guard let hit = self.hitTest(point, options: [SCNHitTestOption.categoryBitMask : SceneGraphCategory.surface.rawValue | SceneGraphCategory.surfaceChunk.rawValue]).first else { return .zero }
        
        let vector = Vector(vector: hit.worldCoordinates)
        
        return Coordinate(x: Int(round(vector.x)), y: Int(vector.y / World.Constants.slope), z: Int(round(vector.z)))
    }
}
