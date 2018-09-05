//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Area: Grid<AreaChunk, AreaTile, AreaNode>, GridIntermediateLoader {
    
    public typealias IntermediateType = AreaNodeIntermediate
}

extension Area {
    
    public func load(nodes: [AreaNodeIntermediate]) {
    
        nodes.forEach { intermediate in
            
            if let node = add(node: intermediate.volume.coordinate) {
                
                node.externalAreaType = intermediate.externalAreaType
                node.internalAreaType = intermediate.internalAreaType
                node.floorColorPalette = ColorPalettes.shared.palette(named: intermediate.floorColorPalette)
                
                if let edge = intermediate.edges.north, let externalColorPalette = ColorPalettes.shared.palette(named: edge.externalColorPalette), let internalColorPalette = ColorPalettes.shared.palette(named: edge.internalColorPalette) {
                    
                    node.set(edge: AreaNode.Edge(edge: edge.edge, edgeType: edge.edgeType, architectureType: edge.architectureType, externalColorPalette: externalColorPalette, internalColorPalette: internalColorPalette))
                }
                
                if let edge = intermediate.edges.east, let externalColorPalette = ColorPalettes.shared.palette(named: edge.externalColorPalette), let internalColorPalette = ColorPalettes.shared.palette(named: edge.internalColorPalette) {
                    
                    node.set(edge: AreaNode.Edge(edge: edge.edge, edgeType: edge.edgeType, architectureType: edge.architectureType, externalColorPalette: externalColorPalette, internalColorPalette: internalColorPalette))
                }
                
                if let edge = intermediate.edges.south, let externalColorPalette = ColorPalettes.shared.palette(named: edge.externalColorPalette), let internalColorPalette = ColorPalettes.shared.palette(named: edge.internalColorPalette) {
                    
                    node.set(edge: AreaNode.Edge(edge: edge.edge, edgeType: edge.edgeType, architectureType: edge.architectureType, externalColorPalette: externalColorPalette, internalColorPalette: internalColorPalette))
                }
                
                if let edge = intermediate.edges.west, let externalColorPalette = ColorPalettes.shared.palette(named: edge.externalColorPalette), let internalColorPalette = ColorPalettes.shared.palette(named: edge.internalColorPalette) {
                    
                    node.set(edge: AreaNode.Edge(edge: edge.edge, edgeType: edge.edgeType, architectureType: edge.architectureType, externalColorPalette: externalColorPalette, internalColorPalette: internalColorPalette))
                }
            }
        }
    }
}

extension Area {
    
    public func add(node coordinate: Coordinate) -> AreaNode? {
        
        guard let node = add(node: AreaNode.fixedVolume(coordinate)) else { return nil }
        
        node.externalAreaType = AreaType.brick
        node.internalAreaType = AreaType.concrete
        node.floorColorPalette = ColorPalettes.shared.all.first
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
}
