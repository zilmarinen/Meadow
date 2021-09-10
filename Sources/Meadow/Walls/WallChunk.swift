//
//  WallChunk.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import Euclid
import SceneKit

public class WallChunk: Chunk<WallTile> {
    
    public override var category: SceneGraphCategory { .wallChunk }
    
    public override var program: SCNProgram? { map?.walls.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? {
        
        guard let image = MDWImage.asset(named: "walls", in: .module) else { return nil }
        
        return [Texture(key: "image", image: image)]
    }
    
    public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        var mesh = Mesh([])
        
        for tile in tiles {
            
            guard let prop = scene?.props.prop(wall: tile.tileType, material: tile.material, pattern: tile.pattern, external: tile.external) else { continue }
    
            let rotation = Rotation(yaw: Angle(radians: (Double.pi / 2.0) * Double(tile.pattern.edge)))
    
            let transform = Transform(offset: Vector(x: Double(tile.coordinate.x - bounds.start.x), y: Double(tile.coordinate.y) * World.Constants.slope, z: Double(tile.coordinate.z - bounds.start.z)), rotation: rotation)
    
            mesh = mesh.merge(prop.mesh.transformed(by: transform))
        }
        
        geometry = SCNGeometry(mesh)
        
        return super.clean()
    }
}
