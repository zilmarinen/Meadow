//
//  BuildingTile.swift
//
//  Created by Zack Brown on 26/01/2021.
//

import Foundation

public class BuildingTile: LayeredTile<BuildingLayer> {
    
    enum Constants {
        
        static let foundation = World.Constants.slope
        static let wall = (World.Constants.slope * 4)
        static let inset = 0.05
    }
    
    public override var category: Int { SceneGraphCategory.buildingTile.rawValue }
    
    public override func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
    
    override func traversable(cardinal: Cardinal) -> Bool { false }
    
    override func collapse() {
        
        //
    }
    
    override func render(position: Vector) -> [Polygon] {
        
        var polygons: [Polygon] = []
        
        let tileVectors = Ordinal.allCases.map { position + $0.vector + Vector(x: 0.0, y: World.Constants.slope * Double(coordinate.y), z: 0.0) }
        var tileInsetVectors = tileVectors
        
        for cardinal in Cardinal.allCases {
            
            let neighbour = find(neighbour: cardinal)
            
            if neighbour != nil { continue }
            
            let (o0, o1) = cardinal.ordinals
            let (o2, o3) = cardinal.opposite.ordinals
            
            tileInsetVectors[o0.rawValue] = tileInsetVectors[o0.rawValue].lerp(vector: tileVectors[o3.rawValue], interpolater: Constants.inset)
            tileInsetVectors[o1.rawValue] = tileInsetVectors[o1.rawValue].lerp(vector: tileVectors[o2.rawValue], interpolater: Constants.inset)
        }
        
        for index in 0..<layers.count {
            
            let layer = layers[index]
            let offset = Vector(x: 0.0, y: (Double(index) * (Constants.foundation + Constants.wall)), z: 0.0)
            
            let layerVectors = tileVectors.map { $0 + offset }
            let layerInsetVectors = tileInsetVectors.map { $0 + offset }
            
            let foundationVectors = layerVectors.map { $0 + Vector(x: 0.0, y: Constants.foundation, z: 0.0) }
            let wallLowerVectors = layerInsetVectors.map { $0 + Vector(x: 0.0, y: Constants.foundation, z: 0.0) }
            let wallUpperVectors = layerInsetVectors.map { $0 + Vector(x: 0.0, y: Constants.foundation + Constants.wall, z: 0.0) }
            
            var color = TerrainTileType.dirt.color
            
            for cardinal in Cardinal.allCases {
                
                let (o0, o1) = cardinal.ordinals
            
                if layer.upper == nil {
                
                    let normal = wallUpperVectors.normal()
                    let centre = wallUpperVectors.average()
                
                    color = TerrainTileType.dirt.color
                
                    polygons.append(Polygon(vertices: [Vertex(position: wallUpperVectors[o0.rawValue], normal: normal, color: color),
                                                   Vertex(position: centre, normal: normal, color: color),
                                                   Vertex(position: wallUpperVectors[o1.rawValue], normal: normal, color: color)]))
                }
                
                if layer.lower == nil {
                    
                    color = TerrainTileType.sand.color
                
                    polygons.append(Polygon(vertices: [Vertex(position: foundationVectors[o0.rawValue], normal: cardinal.normal, color: color, textureCoordinates: CGPoint(x: 0.0, y: 1.0)),
                                                       Vertex(position: foundationVectors[o1.rawValue], normal: cardinal.normal, color: color, textureCoordinates: CGPoint(x: 1.0, y: 1.0)),
                                                       Vertex(position: layerVectors[o1.rawValue], normal: cardinal.normal, color: color, textureCoordinates: CGPoint(x: 1.0, y: 0.0)),
                                                       Vertex(position: layerVectors[o0.rawValue], normal: cardinal.normal, color: color, textureCoordinates: CGPoint(x: 0.0, y: 0.0))]))
                    
                    polygons.append(Polygon(vertices: [Vertex(position: wallLowerVectors[o0.rawValue], normal: .up, color: color, textureCoordinates: CGPoint(x: 0.0, y: 1.0)),
                                                       Vertex(position: wallLowerVectors[o1.rawValue], normal: .up, color: color, textureCoordinates: CGPoint(x: 1.0, y: 1.0)),
                                                       Vertex(position: foundationVectors[o1.rawValue], normal: .up, color: color, textureCoordinates: CGPoint(x: 1.0, y: 0.0)),
                                                       Vertex(position: foundationVectors[o0.rawValue], normal: .up, color: color, textureCoordinates: CGPoint(x: 0.0, y: 0.0))]))
                }
            
                polygons.append(Polygon(vertices: [Vertex(position: wallUpperVectors[o0.rawValue], normal: cardinal.normal, color: layer.color, textureCoordinates: CGPoint(x: 0.0, y: 1.0)),
                                                   Vertex(position: wallUpperVectors[o1.rawValue], normal: cardinal.normal, color: layer.color, textureCoordinates: CGPoint(x: 1.0, y: 1.0)),
                                                   Vertex(position: wallLowerVectors[o1.rawValue], normal: cardinal.normal, color: layer.color, textureCoordinates: CGPoint(x: 1.0, y: 0.0)),
                                                   Vertex(position: wallLowerVectors[o0.rawValue], normal: cardinal.normal, color: layer.color, textureCoordinates: CGPoint(x: 0.0, y: 0.0))]))
            }
        }
        
        return polygons
    }
}
