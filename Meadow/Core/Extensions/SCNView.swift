//
//  SCNView.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 15/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture
import SceneKit

extension SCNView {
    
    public typealias SCNViewHit = (vector: Vector, quad: Graph.Quad?, joint: Graph.Joint?, corner: Vector?)
    
    public func hitTest(point: CGPoint, category: SceneGraphNodeCategory) -> SCNViewHit? {
        
        let options: [SCNHitTestOption : Any] = [SCNHitTestOption.categoryBitMask : category.rawValue]
        
        guard let scene = scene as? Scene, let hit = hitTest(point, options: options).first else { return nil }
        
        let vector = Vector(vector: hit.worldCoordinates)
        
        if let quad = scene.meadow.graph.nearest(quad: vector) {
            
            let joint = scene.meadow.graph.nearest(joint: quad.i, vector: vector)
        
            let corner = scene.meadow.graph.nearest(corner: quad.i, vector: vector)
            
            return (vector: vector, quad: quad, joint: joint, corner: corner)
        }

        return (vector: vector, quad: nil, joint: nil, corner: nil)
    }
}
