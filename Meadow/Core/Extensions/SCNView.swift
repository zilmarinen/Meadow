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
    
    typealias SCNViewHit = (coordinate: Vector, cardinal: GraphCache.Edge, ordinal: GraphCache.Edge)
    
    func hitTest(point: CGPoint) -> SCNViewHit? {
        
        let options: [SCNHitTestOption : Any] = [:]
        
        guard let hit = hitTest(point, options: options).first else { return nil }
        
        let vector = Vector(vector: hit.worldCoordinates)
        //TODO: FIX ME
        return nil
        //return (coordinate: Vector(vector: hit.worldCoordinates), cardinal: Cardinal.closest(vector: vector), ordinal: Ordinal.closest(vector: vector))
    }
}
