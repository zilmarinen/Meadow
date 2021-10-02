//
//  Portals.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class Portals: PropGrid<PortalChunk> {
    
    public func find(portal coordinate: Coordinate) -> PortalChunk? {
        
        return chunks.first { $0.coordinate == coordinate }
    }
    
    public func find(portal identifier: String) -> PortalChunk? {
        
        return chunks.first { $0.identifier == identifier }
    }
    
    public func find(portal type: PortalType) -> PortalChunk? {
        
        return chunks.first { $0.portalType == type }
    }
    
    public func find(portals type: PortalType) -> [PortalChunk] {
        
        return chunks.filter { $0.portalType == type }
    }
}
