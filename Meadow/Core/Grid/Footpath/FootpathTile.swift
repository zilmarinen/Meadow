//
//  FootpathTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class FootpathTile: LayeredTile<FootpathEdge, FootpathLayer> {
    
    enum Constants {
        
        static let height = 1
    }
    
    public override var category: SceneGraphNodeCategory { return .footpath }
    
    override func polytope(forApex edge: Int, atIndex index: Int) -> GridMesh.Polytope? {

        guard let layer = find(edge: edge)?.find(layer: index) else { return nil }
        
        let (v0, centre, v1) = vertices(for: edge)

        let p0 = GridMesh.Elevation(elevation: layer.corners.left.elevation + Constants.height, vector: v0.lerp(vector: centre, interpolater: 0.1))
        let p1 = GridMesh.Elevation(elevation: layer.corners.centre.elevation + Constants.height, vector: centre)
        let p2 = GridMesh.Elevation(elevation: layer.corners.right.elevation + Constants.height, vector: v1.lerp(vector: centre, interpolater: 0.1))

        return GridMesh.Polytope(p0: p0, p1: p1, p2: p2)
    }
    
    override func polytope(forThrone edge: Int, atIndex index: Int) -> GridMesh.Polytope? {

        guard let layer = find(edge: edge)?.find(layer: index) else { return nil }
        
        let (v0, centre, v1) = vertices(for: edge)

        let p0 = GridMesh.Elevation(elevation: layer.corners.left.elevation, vector: v0.lerp(vector: centre, interpolater: 0.1))
        let p1 = GridMesh.Elevation(elevation: layer.corners.centre.elevation, vector: centre)
        let p2 = GridMesh.Elevation(elevation: layer.corners.right.elevation, vector: v1.lerp(vector: centre, interpolater: 0.1))

        return GridMesh.Polytope(p0: p0, p1: p1, p2: p2)
    }
    
    override func colorPalette(apex edge: Int, atIndex index: Int) -> ColorPalette {

        guard let layer = find(edge: edge)?.topLayer else { return .default }

        return ColorPalette(primary: layer.footpathType.primaryColor, secondary: layer.footpathType.secondaryColor)
    }

    override func colorPalette(face edge: Int, atIndex index: Int) -> ColorPalette {

        guard let layer = find(edge: edge)?.topLayer else { return .default }

        return ColorPalette(primary: layer.footpathType.primaryColor, secondary: layer.footpathType.secondaryColor)
    }
}
