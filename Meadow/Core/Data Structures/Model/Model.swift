//
//  Model.swift
//  Meadow
//
//  Created by Zack Brown on 21/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public struct Model: Codable {
    
    public let name: String
    
    public let groups: [ModelGroup]
    
    public init?(named: String) {
        
        let resource = named.lowercased().replacingOccurrences(of: " ", with: "_")
        
        do {
            
            guard let path = Bundle.meadow.path(forResource: resource, ofType: "model") else { return nil }
            
            let data = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            self = try decoder.decode(Model.self, from: data)
        }
        catch {
            
            fatalError("Unable to load Model from file -> \(resource).model")
        }
    }
    
    public init(name: String, groups: [ModelGroup]) {
        
        self.name = name
        self.groups = groups
    }
}

extension Model {
    
    public func mesh(colorPalette: ColorPalette) -> Mesh {
        
        var meshFaces: [MeshFace] = []
        
        groups.forEach { group in
        
            group.faces.forEach { face in
            
                if let color = colorPalette.child(at: face.color) {
            
                    let meshFace = MeshFace(v0: face.v0, v1: face.v1, v2: face.v2, normal: face.normal, color: color.vector)
                
                    meshFaces.append(meshFace)
                }
            }
        }
        
        return Mesh(faces: meshFaces)
    }
}
