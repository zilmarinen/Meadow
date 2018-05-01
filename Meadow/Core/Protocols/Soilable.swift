//
//  Soilable.swift
//  Meadow
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol Soilable {
    
    var isDirty: Bool { get }
    
    func becomeDirty()
    func clean()
}
