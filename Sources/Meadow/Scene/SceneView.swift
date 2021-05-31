//
//  SceneView.swift
//
//  Created by Zack Brown on 08/01/2021.
//

import SceneKit

open class SceneView: SCNView {
    
    public var library: MTLLibrary? {
        
        didSet {
            
            guard let value = library else { return }
            
            //self.technique = SCNTechnique(name: "Technique", library: value)
        }
    }
    
    public override var scene: SCNScene? {
        
        willSet {
            
            guard let value = newValue as? Scene else { return }
            
            value.library = library
        }
    }
}

extension SceneView {
    
    public func hitTest(point: CGPoint) -> Coordinate {
        
        let options = [SCNHitTestOption.categoryBitMask :
                        SceneGraphCategory.bridges.rawValue |
                        SceneGraphCategory.bridgeChunk.rawValue |
                        SceneGraphCategory.stairs.rawValue |
                        SceneGraphCategory.stairChunk.rawValue |
                        SceneGraphCategory.surface.rawValue |
                        SceneGraphCategory.surfaceChunk.rawValue]
        
        guard let hit = self.hitTest(point, options: options).first else { return .zero }
        
        let vector = Vector(vector: hit.worldCoordinates)
        
        return Coordinate(x: Int(round(vector.x)), y: Int(vector.y / World.Constants.slope), z: Int(round(vector.z)))
    }
}
