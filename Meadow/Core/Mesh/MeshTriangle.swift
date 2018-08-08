//
//  MeshTriangle.swift
//  Meadow
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct MeshTriangle {

    let i: Int32
    let j: Int32
    let k: Int32
    
    public var indices: [Int32] { return [i, j, k] }
}

