//
//  BridgeChunk.swift
//
//  Created by Zack Brown on 08/05/2021.
//

import Euclid
import SceneKit

public class BridgeChunk: Chunk<BridgeTile> {
    
    public override var category: Int { SceneGraphCategory.bridgeChunk.rawValue }
    
    public override var program: SCNProgram? { scene?.meadow.bridges.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? {
        
        guard let image = MDWImage.asset(named: "bridges", in: .module) else { return nil }
        
        return [Texture(key: "bridge", image: image)]
    }
}
