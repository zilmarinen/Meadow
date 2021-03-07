//
//  BuildingChunk.swift
//
//  Created by Zack Brown on 26/01/2021.
//

import Foundation
import SceneKit

public class BuildingChunk: Chunk<BuildingTile> {
 
    public override var category: Int { SceneGraphCategory.buildingChunk.rawValue }
    
//    override var program: SCNProgram? {
//
//        guard let library = scene?.library else { return nil }
//
//        return SCNProgram(name: "buildings", library: library)
//    }
//
//    override var uniforms: [Uniform]? { nil }
//
//    override var textures: [Texture]? {
//
//        //TODO: Add buildings tilemap?
//        //guard let tilemap = scene?.world.tilemaps.footpath else { return [] }
//
//        #if os(macOS)
//
//        guard let image = Bundle.module.image(forResource: "Buildings_Edgeset") else { return [] }
//
//        #else
//
//        guard let image = MDWImage(named: "Buildings_Edgeset", in: .module, with: nil) else { return [] }
//
//        #endif
//
//        return [Texture(key: "edgemap", image: image)]
//    }
}
