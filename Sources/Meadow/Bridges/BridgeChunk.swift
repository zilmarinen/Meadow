//
//  BridgeChunk.swift
//
//  Created by Zack Brown on 08/05/2021.
//

import Euclid
import SceneKit

public class BridgeChunk: Chunk<BridgeTile> {
    
    public override var category: SceneGraphCategory { .bridgeChunk }
    
    public override var program: SCNProgram? { map?.bridges.program }
    
    public override var textures: [Texture]? {
        
        //TODO: add textures for bridges spanning multiple chunks
        //possibly convert this into a PropGrid?
        guard let image = try? MDWImage.asset(named: "bridges", in: .module) else { return nil }
        
        return [Texture(key: "image", image: image)]
    }
    
    public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        var mesh = Mesh([])
        
        for tile in tiles {
            
            guard let prop = scene?.props.model(prop: tile.prop) else { continue }
            
            var invert = false
            
            switch tile.tileType {
    
            case .corner(let lhs): invert = tile.pattern.count != 2 && lhs
            default: break
            }
            
            let rotation = Rotation(yaw: Angle(radians: (Double.pi / 2.0) * Double(tile.pattern.edge + (invert ? 2 : 0))))
    
            let transform = Transform(offset: Distance(x: Double(tile.coordinate.x - bounds.start.x), y: Double(tile.coordinate.y) * World.Constants.slope, z: Double(tile.coordinate.z - bounds.start.z)), rotation: rotation)
    
            mesh = mesh.merge(prop.mesh.transformed(by: transform))
        }
        
        geometry = SCNGeometry(mesh)
        
        return super.clean()
    }
}
