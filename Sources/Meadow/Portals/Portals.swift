//
//  Portals.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class Portals: FootprintGrid<PortalChunk> {
    
    public func find(portal type: PortalType) -> PortalChunk? {
        
        return chunks.first { $0.portalType == type }
    }
}
